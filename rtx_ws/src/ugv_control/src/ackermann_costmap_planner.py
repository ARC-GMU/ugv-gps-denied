#!/usr/bin/env python3
"""
Minimal Ackermann local planner for ROS Noetic.

Subscribes:
  - ~costmap_topic (nav_msgs/OccupancyGrid)
  - ~odom_topic (nav_msgs/Odometry)
  - ~goal_topic (geometry_msgs/PoseStamped)

Publishes:
    - ~cmd_vel_topic (geometry_msgs/Twist)
  - ~path_topic (nav_msgs/Path)               # chosen rollout
  - ~candidate_paths_topic (nav_msgs/Path)    # optional best-only/simple debug

Planning idea:
  - Sample steering angles
  - Roll out each trajectory with a bicycle model
  - Reject trajectories that collide with the costmap
  - Score survivors by goal distance, obstacle clearance, and steering smoothness
    - Publish best cmd_vel command
"""

import math
import threading

import rospy
from geometry_msgs.msg import PoseStamped, Quaternion, Twist
from nav_msgs.msg import OccupancyGrid, Odometry, Path
from tf.transformations import quaternion_from_euler


def clamp(value, low, high):
    return max(low, min(high, value))


def yaw_from_quaternion(q):
    siny_cosp = 2.0 * (q.w * q.z + q.x * q.y)
    cosy_cosp = 1.0 - 2.0 * (q.y * q.y + q.z * q.z)
    return math.atan2(siny_cosp, cosy_cosp)


def wrap_angle(angle):
    while angle > math.pi:
        angle -= 2.0 * math.pi
    while angle < -math.pi:
        angle += 2.0 * math.pi
    return angle


def make_quaternion_from_yaw(yaw):
    q = quaternion_from_euler(0.0, 0.0, yaw)
    quat = Quaternion()
    quat.x = q[0]
    quat.y = q[1]
    quat.z = q[2]
    quat.w = q[3]
    return quat


class GridMap(object):
    """Light wrapper around nav_msgs/OccupancyGrid."""

    def __init__(self):
        self.msg = None

    def update(self, msg):
        self.msg = msg

    def ready(self):
        return self.msg is not None

    @property
    def resolution(self):
        return self.msg.info.resolution

    @property
    def width(self):
        return self.msg.info.width

    @property
    def height(self):
        return self.msg.info.height

    @property
    def origin_x(self):
        return self.msg.info.origin.position.x

    @property
    def origin_y(self):
        return self.msg.info.origin.position.y

    def world_to_map(self, x, y):
        mx = int(math.floor((x - self.origin_x) / self.resolution))
        my = int(math.floor((y - self.origin_y) / self.resolution))
        if mx < 0 or my < 0 or mx >= self.width or my >= self.height:
            return None
        return mx, my

    def get_cost(self, x, y):
        """Returns occupancy in [-1, 100], or 0 if outside map (traversable)."""
        idx = self.world_to_map(x, y)
        if idx is None:
            return 0
        mx, my = idx
        flat = my * self.width + mx
        return self.msg.data[flat]

    def is_occupied(self, x, y, occupied_threshold=50, treat_unknown_as_occupied=False):
        cost = self.get_cost(x, y)
        if cost < 0:
            return treat_unknown_as_occupied
        return cost >= occupied_threshold

    def clearance_cost(
        self,
        x,
        y,
        search_radius_m=0.8,
        occupied_threshold=50,
        treat_unknown_as_occupied=False,
    ):
        """
        Returns a penalty based on nearby occupied cells.
        Lower is better.
        Very simple local search around the query point.
        """
        if not self.ready():
            return 1e6

        r_cells = max(1, int(search_radius_m / self.resolution))
        center = self.world_to_map(x, y)
        if center is None:
            return 0.0
        cx, cy = center

        best_dist_sq = None
        for dy in range(-r_cells, r_cells + 1):
            for dx in range(-r_cells, r_cells + 1):
                mx = cx + dx
                my = cy + dy
                if mx < 0 or my < 0 or mx >= self.width or my >= self.height:
                    continue
                idx = my * self.width + mx
                val = self.msg.data[idx]
                occupied = False
                if val < 0:
                    occupied = treat_unknown_as_occupied
                elif val >= occupied_threshold:
                    occupied = True

                if occupied:
                    dist_sq = (dx * self.resolution) ** 2 + (dy * self.resolution) ** 2
                    if best_dist_sq is None or dist_sq < best_dist_sq:
                        best_dist_sq = dist_sq

        if best_dist_sq is None:
            return 0.0  # no nearby obstacle detected
        dist = math.sqrt(best_dist_sq)
        return 1.0 / max(dist, 0.05)


class AckermannCostmapPlanner(object):
    def __init__(self):
        self.lock = threading.Lock()

        # Topics
        self.costmap_topic = rospy.get_param("~costmap_topic", "/move_base/local_costmap/costmap")
        self.odom_topic = rospy.get_param("~odom_topic", "/odom")
        self.goal_topic = rospy.get_param("~goal_topic", "/local_goal")
        self.cmd_vel_topic = rospy.get_param(
            "~cmd_vel_topic", rospy.get_param("~drive_topic", "/cmd_vel")
        )
        self.path_topic = rospy.get_param("~path_topic", "/planner_path")
        self.candidate_paths_topic = rospy.get_param("~candidate_paths_topic", "/planner_candidates")

        # Frames
        self.base_frame = rospy.get_param("~base_frame", "base_link")

        # Vehicle params
        self.wheelbase = rospy.get_param("~wheelbase", 0.32)  # meters
        self.max_steer = rospy.get_param("~max_steer", 0.40)  # rad
        self.nominal_speed = rospy.get_param("~nominal_speed", 0.8)  # m/s
        self.min_speed = rospy.get_param("~min_speed", 0.2)  # m/s
        self.max_speed = rospy.get_param("~max_speed", 1.2)  # m/s

        # Rollout params
        self.num_steer_samples = rospy.get_param("~num_steer_samples", 21)
        self.horizon_time = rospy.get_param("~horizon_time", 1.8)  # seconds
        self.dt = rospy.get_param("~dt", 0.1)  # seconds
        self.lookahead_goal_distance = rospy.get_param("~lookahead_goal_distance", 1.5)

        # Collision params
        self.robot_radius = rospy.get_param("~robot_radius", 0.25)
        self.occupied_threshold = rospy.get_param("~occupied_threshold", 50)
        self.treat_unknown_as_occupied = rospy.get_param("~treat_unknown_as_occupied", False)
        self.collision_check_points = rospy.get_param("~collision_check_points", 7)

        # Scoring weights
        self.w_goal = rospy.get_param("~w_goal", 4.0)
        self.w_heading = rospy.get_param("~w_heading", 1.5)
        self.w_clearance = rospy.get_param("~w_clearance", 1.0)
        self.w_steer = rospy.get_param("~w_steer", 0.25)
        self.w_steer_change = rospy.get_param("~w_steer_change", 0.5)

        # Safety / stopping
        self.stop_if_no_goal = rospy.get_param("~stop_if_no_goal", True)
        self.stop_if_no_valid_path = rospy.get_param("~stop_if_no_valid_path", True)
        self.goal_tolerance = rospy.get_param("~goal_tolerance", 0.35)

        # State
        self.grid = GridMap()
        self.current_pose = None  # (x, y, yaw)
        self.current_speed = 0.0
        self.goal = None  # (x, y, yaw_opt)
        self.prev_steer = 0.0

        # ROS I/O
        self.costmap_sub = rospy.Subscriber(
            self.costmap_topic, OccupancyGrid, self.costmap_callback, queue_size=1
        )
        self.odom_sub = rospy.Subscriber(
            self.odom_topic, Odometry, self.odom_callback, queue_size=1
        )
        self.goal_sub = rospy.Subscriber(
            self.goal_topic, PoseStamped, self.goal_callback, queue_size=1
        )

        self.drive_pub = rospy.Publisher(self.cmd_vel_topic, Twist, queue_size=1)
        self.path_pub = rospy.Publisher(self.path_topic, Path, queue_size=1)
        self.candidate_pub = rospy.Publisher(self.candidate_paths_topic, Path, queue_size=1)

        self.rate_hz = rospy.get_param("~rate", 10.0)
        self.timer = rospy.Timer(rospy.Duration(1.0 / self.rate_hz), self.plan_timer)

        rospy.loginfo("AckermannCostmapPlanner initialized.")

    def costmap_callback(self, msg):
        with self.lock:
            self.grid.update(msg)

    def odom_callback(self, msg):
        with self.lock:
            px = msg.pose.pose.position.x
            py = msg.pose.pose.position.y
            yaw = yaw_from_quaternion(msg.pose.pose.orientation)
            self.current_pose = (px, py, yaw)
            self.current_speed = msg.twist.twist.linear.x

    def goal_callback(self, msg):
        with self.lock:
            gx = msg.pose.position.x
            gy = msg.pose.position.y
            gyaw = yaw_from_quaternion(msg.pose.orientation)
            self.goal = (gx, gy, gyaw)

    def plan_timer(self, _event):
        with self.lock:
            if not self.grid.ready() or self.current_pose is None:
                return

            if self.goal is None:
                if self.stop_if_no_goal:
                    self.publish_stop()
                return

            robot_x, robot_y, robot_yaw = self.current_pose
            goal_x, goal_y, _ = self.goal

            goal_dist = math.hypot(goal_x - robot_x, goal_y - robot_y)
            if goal_dist < self.goal_tolerance:
                self.publish_stop()
                return

            best = self.compute_best_rollout()
            if best is None:
                rospy.logwarn_throttle(1.0, "No valid rollout found.")
                if self.stop_if_no_valid_path:
                    self.publish_stop()
                return

            best_steer, best_speed, best_path_msg, debug_path_msg = best
            self.prev_steer = best_steer

            self.path_pub.publish(best_path_msg)
            self.candidate_pub.publish(debug_path_msg)
            self.publish_drive(best_speed, best_steer)

    def compute_best_rollout(self):
        robot_x, robot_y, robot_yaw = self.current_pose
        goal_x, goal_y, _ = self.goal

        steer_samples = self.generate_steering_samples()

        best_score = None
        best_result = None
        best_debug_path = None

        for steer in steer_samples:
            speed = self.choose_speed_for_steer(steer)
            rollout = self.rollout_bicycle(robot_x, robot_y, robot_yaw, speed, steer)
            if not rollout:
                continue

            collision = False
            min_clearance_penalty = 0.0

            for px, py, pyaw in rollout:
                if self.trajectory_pose_in_collision(px, py, pyaw):
                    collision = True
                    break
                clr_pen = self.grid.clearance_cost(
                    px,
                    py,
                    search_radius_m=max(0.7, self.robot_radius * 2.0),
                    occupied_threshold=self.occupied_threshold,
                    treat_unknown_as_occupied=self.treat_unknown_as_occupied,
                )
                min_clearance_penalty = max(min_clearance_penalty, clr_pen)

            if collision:
                continue

            end_x, end_y, end_yaw = rollout[-1]

            dist_goal = math.hypot(goal_x - end_x, goal_y - end_y)
            desired_heading = math.atan2(goal_y - end_y, goal_x - end_x)
            heading_err = abs(wrap_angle(desired_heading - end_yaw))

            score = (
                self.w_goal * dist_goal
                + self.w_heading * heading_err
                + self.w_clearance * min_clearance_penalty
                + self.w_steer * abs(steer)
                + self.w_steer_change * abs(steer - self.prev_steer)
            )

            if best_score is None or score < best_score:
                best_score = score
                best_path_msg = self.rollout_to_path(rollout)
                best_debug_path = best_path_msg
                best_result = (steer, speed, best_path_msg, best_debug_path)

        return best_result

    def generate_steering_samples(self):
        n = max(3, int(self.num_steer_samples))
        if n % 2 == 0:
            n += 1  # prefer symmetric odd count
        samples = []
        for i in range(n):
            alpha = float(i) / float(n - 1)
            steer = -self.max_steer + 2.0 * self.max_steer * alpha
            samples.append(steer)

        # Bias toward reusing current steering for smoother behavior
        samples.append(clamp(self.prev_steer, -self.max_steer, self.max_steer))
        samples = sorted(set([round(s, 5) for s in samples]))
        return samples

    def choose_speed_for_steer(self, steer):
        """
        Reduce speed on high steering angles.
        """
        steer_ratio = abs(steer) / max(self.max_steer, 1e-6)
        speed = self.nominal_speed * (1.0 - 0.55 * steer_ratio)
        return clamp(speed, self.min_speed, self.max_speed)

    def rollout_bicycle(self, x0, y0, yaw0, speed, steer):
        steps = max(1, int(self.horizon_time / self.dt))
        x = x0
        y = y0
        yaw = yaw0
        pts = []

        for _ in range(steps):
            x += speed * math.cos(yaw) * self.dt
            y += speed * math.sin(yaw) * self.dt
            yaw += (speed / self.wheelbase) * math.tan(steer) * self.dt
            yaw = wrap_angle(yaw)
            pts.append((x, y, yaw))

        return pts

    def trajectory_pose_in_collision(self, x, y, yaw):
        """
        Approximate the robot footprint by sampling a few circles/points along the body axis.
        """
        half_length = self.robot_radius
        sample_count = max(3, int(self.collision_check_points))

        for i in range(sample_count):
            if sample_count == 1:
                offset = 0.0
            else:
                alpha = float(i) / float(sample_count - 1)
                offset = -half_length + 2.0 * half_length * alpha

            px = x + offset * math.cos(yaw)
            py = y + offset * math.sin(yaw)

            if self.grid.is_occupied(
                px,
                py,
                occupied_threshold=self.occupied_threshold,
                treat_unknown_as_occupied=self.treat_unknown_as_occupied,
            ):
                return True

            # also check a small lateral width
            lateral = self.robot_radius * 0.75
            lx = px - lateral * math.sin(yaw)
            ly = py + lateral * math.cos(yaw)
            rx = px + lateral * math.sin(yaw)
            ry = py - lateral * math.cos(yaw)

            if self.grid.is_occupied(
                lx,
                ly,
                occupied_threshold=self.occupied_threshold,
                treat_unknown_as_occupied=self.treat_unknown_as_occupied,
            ):
                return True
            if self.grid.is_occupied(
                rx,
                ry,
                occupied_threshold=self.occupied_threshold,
                treat_unknown_as_occupied=self.treat_unknown_as_occupied,
            ):
                return True

        return False

    def rollout_to_path(self, rollout):
        path = Path()
        path.header.stamp = rospy.Time.now()
        path.header.frame_id = self.grid.msg.header.frame_id if self.grid.msg else "map"

        for x, y, yaw in rollout:
            pose = PoseStamped()
            pose.header = path.header
            pose.pose.position.x = x
            pose.pose.position.y = y
            pose.pose.position.z = 0.0
            pose.pose.orientation = make_quaternion_from_yaw(yaw)
            path.poses.append(pose)

        return path

    def publish_drive(self, speed, steer):
        msg = Twist()
        msg.linear.x = speed
        # Approximate Ackermann steering as yaw-rate command for cmd_vel output.
        msg.angular.z = (speed / max(self.wheelbase, 1e-6)) * math.tan(steer)
        self.drive_pub.publish(msg)

    def publish_stop(self):
        self.publish_drive(0.0, self.prev_steer)


def main():
    rospy.init_node("ackermann_costmap_planner")
    AckermannCostmapPlanner()
    rospy.spin()


if __name__ == "__main__":
    main()