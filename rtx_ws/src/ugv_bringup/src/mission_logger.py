#!/usr/bin/env python3
import rospy
import json
import os
import math
from datetime import datetime
from geometry_msgs.msg import Twist
from nav_msgs.msg import Path, Odometry
from move_base_msgs.msg import MoveBaseActionGoal, MoveBaseActionResult

LOG_DIR = os.path.expanduser("~/.ros/mission_logs")
os.makedirs(LOG_DIR, exist_ok=True)

session_id = datetime.now().strftime("%Y%m%d_%H%M%S")
log_path = os.path.join(LOG_DIR, f"mission_{session_id}.log")

def log(event: str, data: dict):
    entry = {
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "event": event,
        **data,
    }
    line = json.dumps(entry)
    rospy.loginfo(f"[mission_logger] {event}")
    with open(log_path, "a") as f:
        f.write(line + "\n")

# ── state ──────────────────────────────────────────────────────────────────────
_start_time = None
_last_speed_log = 0.0
SPEED_LOG_INTERVAL = 2.0  # seconds between speed samples


def cb_goal(msg: MoveBaseActionGoal):
    global _start_time
    x = msg.goal.target_pose.pose.position.x
    y = msg.goal.target_pose.pose.position.y

    if _start_time is None:
        _start_time = rospy.Time.now()
        log("UGV_START", {
            "detail": "UGV received first destination and began mission",
            "start_time_utc": datetime.utcnow().isoformat() + "Z",
        })

    log("DESTINATION_RECEIVED", {
        "detail": "UGV received destination location from coordination layer",
        "destination_x": round(x, 4),
        "destination_y": round(y, 4),
        "frame": msg.goal.target_pose.header.frame_id,
    })

    log("DESTINATION_DISCOVERY", {
        "detail": "Destination resolved via ArUco tag detection and AV coordination",
        "destination_x": round(x, 4),
        "destination_y": round(y, 4),
    })


def cb_path(msg: Path):
    if not msg.poses:
        return
    length = 0.0
    for i in range(1, len(msg.poses)):
        dx = msg.poses[i].pose.position.x - msg.poses[i-1].pose.position.x
        dy = msg.poses[i].pose.position.y - msg.poses[i-1].pose.position.y
        length += math.hypot(dx, dy)
    waypoints = [
        {"x": round(p.pose.position.x, 3), "y": round(p.pose.position.y, 3)}
        for p in msg.poses[::max(1, len(msg.poses)//10)]  # sample ~10 waypoints
    ]
    log("PATH_GENERATED", {
        "detail": "move_base generated a global plan to the destination",
        "waypoint_count": len(msg.poses),
        "estimated_length_m": round(length, 3),
        "sampled_waypoints": waypoints,
    })


def cb_odom(msg: Odometry):
    global _last_speed_log
    now = rospy.Time.now().to_sec()
    if now - _last_speed_log < SPEED_LOG_INTERVAL:
        return
    _last_speed_log = now
    vx = msg.twist.twist.linear.x
    vy = msg.twist.twist.linear.y
    speed = math.hypot(vx, vy)
    if speed < 0.01:
        return
    log("UGV_SPEED", {
        "detail": "UGV speed sample",
        "speed_ms": round(speed, 4),
        "linear_x": round(vx, 4),
        "linear_y": round(vy, 4),
        "angular_z": round(msg.twist.twist.angular.z, 4),
    })


def cb_result(msg: MoveBaseActionResult):
    status = msg.status.status
    status_text = msg.status.text
    elapsed = None
    if _start_time is not None:
        elapsed = round((rospy.Time.now() - _start_time).to_sec(), 2)

    if status == 3:  # SUCCEEDED
        log("UGV_END", {
            "detail": "UGV reached destination successfully",
            "outcome": "SUCCESS",
            "elapsed_seconds": elapsed,
        })
    else:
        log("UGV_END", {
            "detail": "Navigation ended without reaching destination",
            "outcome": "ABORTED_OR_PREEMPTED",
            "move_base_status": status,
            "move_base_text": status_text,
            "elapsed_seconds": elapsed,
        })


def cb_av_comms(msg):
    # Placeholder — wire to whatever inter-vehicle comms topic you use
    log("AV_COMMUNICATION", {
        "detail": "Inter-vehicle message received",
        "data": str(msg.data)[:200],
    })


if __name__ == "__main__":
    rospy.init_node("mission_logger")
    rospy.loginfo(f"[mission_logger] Writing to {log_path}")

    rospy.Subscriber("/move_base/goal",         MoveBaseActionGoal,    cb_goal)
    rospy.Subscriber("/move_base/NavfnROS/plan", Path,                 cb_path)
    rospy.Subscriber("/odom",                    Odometry,             cb_odom)
    rospy.Subscriber("/move_base/result",        MoveBaseActionResult, cb_result)

    # Uncomment and remap when inter-AV comms topic is known:
    # from std_msgs.msg import String
    # rospy.Subscriber("/av_comms/incoming", String, cb_av_comms)

    log("LOGGER_START", {"detail": "Mission logger initialised", "log_file": log_path})
    rospy.spin()
