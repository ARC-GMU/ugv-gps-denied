#include <rtx_navigation/sampling_ackermann_planner.h>

#include <algorithm>
#include <cmath>
#include <limits>

#include <costmap_2d/cost_values.h>
#include <pluginlib/class_list_macros.h>
#include <tf2_geometry_msgs/tf2_geometry_msgs.h>
#include <tf2/utils.h>

namespace rtx_navigation
{
SamplingAckermannPlanner::SamplingAckermannPlanner()
  : initialized_(false)
  , goal_reached_(false)
  , tf_(nullptr)
  , costmap_ros_(nullptr)
  , external_goal_received_(false)
  , external_path_received_(false)
  , have_last_goal_(false)
  , last_plan_time_(0.0)
  , wheelbase_(0.7)
  , track_width_(0.4)
  , dt_(0.1)
  , planning_frequency_(5.0)
  , incremental_segments_(4)
  , replan_deviation_threshold_(0.6)
  , rollout_steps_(10)
  , max_segments_(30)
  , steering_samples_(11)
  , mppi_num_rollouts_(128)
  , max_steering_rad_(M_PI / 4.0)
  , max_speed_(0.15)
  , min_speed_(0.12)
  , mppi_noise_sigma_rad_(0.22)
  , mppi_temperature_(0.25)
  , mppi_control_weight_(0.02)
  , mppi_progress_weight_(0.08)
  , mppi_terminal_weight_(1.4)
  , reverse_enabled_(true)
  , max_reverse_speed_(0.12)
  , min_reverse_speed_(0.08)
  , reverse_heading_threshold_rad_(2.2)
  , reverse_release_heading_threshold_rad_(1.5)
  , forward_priority_bias_(0.35)
  , use_path_planning_(false)
  , lookahead_distance_(0.8)
  , path_goal_lookahead_distance_(1.2)
  , min_steering_norm_cmd_(0.15)
  , heading_turn_threshold_rad_(0.12)
  , goal_stop_buffer_(0.15)
  , goal_xy_tolerance_(0.3)
  , goal_yaw_tolerance_(0.5)
  , enable_final_reorientation_(true)
  , final_reorient_speed_(0.08)
  , final_reorient_steering_norm_(0.35)
  , obstacle_cost_penalty_(0.1)
  , lethal_cost_threshold_(costmap_2d::INSCRIBED_INFLATED_OBSTACLE)
  , pid_kp_(1.8)
  , pid_ki_(0.02)
  , pid_kd_(0.2)
  , pid_cte_kp_(0.7)
  , pid_integral_limit_(0.6)
  , heading_integral_(0.0)
  , last_heading_error_(0.0)
  , has_last_heading_error_(false)
  , last_dist_to_goal_(std::numeric_limits<double>::infinity())
  , have_last_dist_to_goal_(false)
  , reverse_mode_latched_(false)
{
}

void SamplingAckermannPlanner::initialize(std::string name, tf2_ros::Buffer* tf, costmap_2d::Costmap2DROS* costmap_ros)
{
  if (initialized_)
  {
    ROS_WARN("SamplingAckermannPlanner was initialized more than once; ignoring repeated initialization.");
    return;
  }

  tf_ = tf;
  costmap_ros_ = costmap_ros;
  nh_ = ros::NodeHandle("~/" + name);
  ros::NodeHandle nh_short("~/SamplingAckermannPlanner");

  auto readDouble = [&](const std::string& key, double& value)
  {
    double out = value;
    if (nh_.getParam(key, out) || nh_short.getParam(key, out))
    {
      value = out;
    }
  };

  auto readInt = [&](const std::string& key, int& value)
  {
    int out = value;
    if (nh_.getParam(key, out) || nh_short.getParam(key, out))
    {
      value = out;
    }
  };

  auto readBool = [&](const std::string& key, bool& value)
  {
    bool out = value;
    if (nh_.getParam(key, out) || nh_short.getParam(key, out))
    {
      value = out;
    }
  };

  auto readString = [&](const std::string& key, std::string& value)
  {
    std::string out = value;
    if (nh_.getParam(key, out) || nh_short.getParam(key, out))
    {
      value = out;
    }
  };

  readDouble("wheelbase", wheelbase_);
  readDouble("track_width", track_width_);
  readDouble("dt", dt_);
  readDouble("planning_frequency", planning_frequency_);
  readInt("incremental_segments", incremental_segments_);
  readDouble("replan_deviation_threshold", replan_deviation_threshold_);
  readInt("rollout_steps", rollout_steps_);
  readInt("max_segments", max_segments_);
  readInt("steering_samples", steering_samples_);
  readInt("mppi_num_rollouts", mppi_num_rollouts_);
  readDouble("max_speed", max_speed_);
  readDouble("min_speed", min_speed_);
  readDouble("mppi_noise_sigma_rad", mppi_noise_sigma_rad_);
  readDouble("mppi_temperature", mppi_temperature_);
  readDouble("mppi_control_weight", mppi_control_weight_);
  readDouble("mppi_progress_weight", mppi_progress_weight_);
  readDouble("mppi_terminal_weight", mppi_terminal_weight_);
  readBool("reverse_enabled", reverse_enabled_);
  readDouble("max_reverse_speed", max_reverse_speed_);
  readDouble("min_reverse_speed", min_reverse_speed_);
  readDouble("reverse_heading_threshold_rad", reverse_heading_threshold_rad_);
  readDouble("reverse_release_heading_threshold_rad", reverse_release_heading_threshold_rad_);
  readDouble("forward_priority_bias", forward_priority_bias_);
  readBool("use_path_planning", use_path_planning_);
  readDouble("lookahead_distance", lookahead_distance_);
  readDouble("path_goal_lookahead_distance", path_goal_lookahead_distance_);
  readDouble("min_steering_norm_cmd", min_steering_norm_cmd_);
  readDouble("heading_turn_threshold_rad", heading_turn_threshold_rad_);
  readDouble("goal_stop_buffer", goal_stop_buffer_);
  readDouble("goal_xy_tolerance", goal_xy_tolerance_);
  readDouble("goal_yaw_tolerance", goal_yaw_tolerance_);
  readBool("enable_final_reorientation", enable_final_reorientation_);
  readDouble("final_reorient_speed", final_reorient_speed_);
  readDouble("final_reorient_steering_norm", final_reorient_steering_norm_);
  readDouble("obstacle_cost_penalty", obstacle_cost_penalty_);

  double max_steering_deg = 45.0;
  readDouble("max_steering_deg", max_steering_deg);
  max_steering_deg = std::min(45.0, std::max(0.0, max_steering_deg));
  max_steering_rad_ = max_steering_deg * M_PI / 180.0;

  int lethal_threshold = static_cast<int>(lethal_cost_threshold_);
  readInt("lethal_cost_threshold", lethal_threshold);
  lethal_threshold = std::max(1, std::min(255, lethal_threshold));
  lethal_cost_threshold_ = static_cast<unsigned char>(lethal_threshold);

  readDouble("pid_kp", pid_kp_);
  readDouble("pid_ki", pid_ki_);
  readDouble("pid_kd", pid_kd_);
  readDouble("pid_cte_kp", pid_cte_kp_);
  readDouble("pid_integral_limit", pid_integral_limit_);

  MPPILinkSampler::Params mppi_params;
  mppi_params.wheelbase = wheelbase_;
  mppi_params.dt = dt_;
  mppi_params.rollout_steps = rollout_steps_;
  mppi_params.num_rollouts = std::max(16, mppi_num_rollouts_);
  mppi_params.max_steering_rad = max_steering_rad_;
  mppi_params.noise_sigma_rad = mppi_noise_sigma_rad_;
  mppi_params.temperature = mppi_temperature_;
  mppi_params.control_weight = mppi_control_weight_;
  mppi_params.progress_weight = mppi_progress_weight_;
  mppi_params.terminal_weight = mppi_terminal_weight_;
  mppi_params.obstacle_cost_penalty = obstacle_cost_penalty_;
  mppi_params.lethal_cost_threshold = lethal_cost_threshold_;

  mppi_sampler_.reset(new MPPILinkSampler(costmap_ros_->getCostmap(), mppi_params));

  std::string rviz_goal_topic = "/move_base_simple_goal";
  std::string goal_topic = "/nav_goal";
  std::string path_topic = "/nav_path";
  readString("rviz_goal_topic", rviz_goal_topic);
  readString("goal_topic", goal_topic);
  readString("path_topic", path_topic);

  goal_sub_rviz_ = nh_.subscribe(rviz_goal_topic, 1, &SamplingAckermannPlanner::goalCallback, this);
  goal_sub_nav_ = nh_.subscribe(goal_topic, 1, &SamplingAckermannPlanner::goalCallback, this);
  path_sub_nav_ = nh_.subscribe(path_topic, 1, &SamplingAckermannPlanner::pathCallback, this);
  path_pub_ = nh_.advertise<nav_msgs::Path>("rollout_path", 1, true);

  initialized_ = true;
  ROS_INFO("SamplingAckermannPlanner initialized (mode=%s, wheelbase=%.3f, track_width=%.3f, dt=%.3f, steering=+/-%.1f deg)",
           use_path_planning_ ? "path" : "goal",
           wheelbase_,
           track_width_,
           dt_,
           max_steering_deg);
}

bool SamplingAckermannPlanner::setPlan(const std::vector<geometry_msgs::PoseStamped>& orig_global_plan)
{
  if (!initialized_)
  {
    ROS_ERROR("SamplingAckermannPlanner is not initialized.");
    return false;
  }

  std::lock_guard<std::mutex> lock(data_mutex_);
  global_plan_ = orig_global_plan;
  cached_rollout_path_.clear();
  have_last_goal_ = false;
  last_plan_time_ = ros::Time(0.0);
  have_last_dist_to_goal_ = false;
  last_dist_to_goal_ = std::numeric_limits<double>::infinity();
  reverse_mode_latched_ = false;
  goal_reached_ = false;
  return true;
}

bool SamplingAckermannPlanner::computeVelocityCommands(geometry_msgs::Twist& cmd_vel)
{
  cmd_vel = geometry_msgs::Twist();

  if (!initialized_ || !costmap_ros_)
  {
    return false;
  }

  geometry_msgs::PoseStamped robot_pose;
  if (!costmap_ros_->getRobotPose(robot_pose))
  {
    ROS_WARN_THROTTLE(1.0, "SamplingAckermannPlanner: failed to get robot pose from costmap.");
    return false;
  }

  if (!hasGoal())
  {
    return false;
  }

  geometry_msgs::PoseStamped planning_goal;
  geometry_msgs::PoseStamped terminal_goal;

  if (use_path_planning_)
  {
    std::vector<geometry_msgs::PoseStamped> target_path;
    if (!resolvePathInCostmapFrame(target_path) || target_path.empty())
    {
      ROS_WARN_THROTTLE(1.0, "SamplingAckermannPlanner: waiting for path transform into %s.",
                        costmap_ros_->getGlobalFrameID().c_str());
      return false;
    }

    terminal_goal = target_path.back();
    planning_goal = selectPathLookaheadGoal(robot_pose, target_path);
  }
  else
  {
    if (!resolveGoalInCostmapFrame(terminal_goal))
    {
      ROS_WARN_THROTTLE(1.0, "SamplingAckermannPlanner: waiting for goal transform into %s.",
                        costmap_ros_->getGlobalFrameID().c_str());
      return false;
    }
    planning_goal = terminal_goal;
  }

  const double robot_x = robot_pose.pose.position.x;
  const double robot_y = robot_pose.pose.position.y;
  const double goal_x = terminal_goal.pose.position.x;
  const double goal_y = terminal_goal.pose.position.y;
  const double dist_to_goal = distance2D(robot_x, robot_y, goal_x, goal_y);
  const double robot_yaw = tf2::getYaw(robot_pose.pose.orientation);
  const double goal_yaw = tf2::getYaw(terminal_goal.pose.orientation);
  const double yaw_error_to_goal = normalizeAngle(goal_yaw - robot_yaw);
  const double stop_dist = goal_xy_tolerance_ + std::max(0.0, goal_stop_buffer_);

  bool passed_goal = false;
  if (have_last_dist_to_goal_)
  {
    // If distance starts increasing while already near goal, we likely passed it.
    if (dist_to_goal > last_dist_to_goal_ + 0.03 && last_dist_to_goal_ < (stop_dist + 0.4))
    {
      passed_goal = true;
    }
  }
  last_dist_to_goal_ = dist_to_goal;
  have_last_dist_to_goal_ = true;

  // Ackermann platform cannot pivot in place; use XY tolerance as terminal condition
  // to avoid circling/overshooting while trying to match final yaw exactly.
  if ((dist_to_goal <= stop_dist || passed_goal) &&
      (!enable_final_reorientation_ || std::abs(yaw_error_to_goal) <= goal_yaw_tolerance_))
  {
    goal_reached_ = true;
    heading_integral_ = 0.0;
    has_last_heading_error_ = false;
    cmd_vel.linear.x = 0.0;
    cmd_vel.angular.z = 0.0;
    return true;
  }

  if (enable_final_reorientation_ && dist_to_goal <= stop_dist && std::abs(yaw_error_to_goal) > goal_yaw_tolerance_)
  {
    goal_reached_ = false;

    const double steer_sign = (yaw_error_to_goal >= 0.0) ? 1.0 : -1.0;
    cmd_vel.linear.x = std::max(0.02, final_reorient_speed_);
    cmd_vel.angular.z = steer_sign * std::max(0.05, std::min(1.0, final_reorient_steering_norm_));
    return true;
  }

  goal_reached_ = false;

  const ros::Time now = ros::Time::now();
  const double plan_period = 1.0 / std::max(0.1, planning_frequency_);
  const bool periodic_plan_due = (now - last_plan_time_).toSec() >= plan_period;
  bool force_full_replan = isGoalChanged(planning_goal);

  {
    std::lock_guard<std::mutex> lock(data_mutex_);
    if (!cached_rollout_path_.empty())
    {
      const size_t nearest_idx = nearestPathIndex(robot_pose, cached_rollout_path_);
      const double path_dist = distance2D(robot_x,
                                          robot_y,
                                          cached_rollout_path_[nearest_idx].pose.position.x,
                                          cached_rollout_path_[nearest_idx].pose.position.y);
      if (path_dist > replan_deviation_threshold_)
      {
        force_full_replan = true;
      }
    }
    else
    {
      force_full_replan = true;
    }
  }

  if (periodic_plan_due || force_full_replan)
  {
    updateCachedPath(robot_pose, planning_goal, force_full_replan);
    last_plan_time_ = now;
    {
      std::lock_guard<std::mutex> lock(data_mutex_);
      last_goal_in_costmap_frame_ = planning_goal;
      have_last_goal_ = true;
    }
  }

  std::vector<geometry_msgs::PoseStamped> rollout_path;
  {
    std::lock_guard<std::mutex> lock(data_mutex_);
    rollout_path = cached_rollout_path_;
  }

  if (rollout_path.empty())
  {
    ROS_WARN_THROTTLE(0.5, "SamplingAckermannPlanner: no valid rollout found.");
    return false;
  }

  nav_msgs::Path debug_path;
  debug_path.header.stamp = ros::Time::now();
  debug_path.header.frame_id = costmap_ros_->getGlobalFrameID();
  debug_path.poses = rollout_path;
  path_pub_.publish(debug_path);

  if (!computePidControl(robot_pose, rollout_path, terminal_goal, cmd_vel))
  {
    return false;
  }

  // angular.z carries normalized steering command in [-1, 1].
  cmd_vel.angular.z = std::max(-1.0, std::min(1.0, cmd_vel.angular.z));

  return true;
}

bool SamplingAckermannPlanner::isGoalReached()
{
  return goal_reached_;
}

void SamplingAckermannPlanner::goalCallback(const geometry_msgs::PoseStamped::ConstPtr& msg)
{
  if (!msg)
  {
    return;
  }

  std::lock_guard<std::mutex> lock(data_mutex_);
  external_goal_ = *msg;
  external_goal_received_ = true;
  goal_reached_ = false;
  have_last_dist_to_goal_ = false;
  last_dist_to_goal_ = std::numeric_limits<double>::infinity();
  reverse_mode_latched_ = false;
}

void SamplingAckermannPlanner::pathCallback(const nav_msgs::Path::ConstPtr& msg)
{
  if (!msg)
  {
    return;
  }

  std::lock_guard<std::mutex> lock(data_mutex_);
  external_path_.clear();
  if (!msg->poses.empty())
  {
    external_path_ = msg->poses;
    external_path_received_ = true;
  }
  else
  {
    external_path_received_ = false;
  }

  goal_reached_ = false;
  have_last_dist_to_goal_ = false;
  last_dist_to_goal_ = std::numeric_limits<double>::infinity();
  reverse_mode_latched_ = false;
}

bool SamplingAckermannPlanner::resolveGoalInCostmapFrame(geometry_msgs::PoseStamped& goal_out)
{
  geometry_msgs::PoseStamped goal;
  {
    std::lock_guard<std::mutex> lock(data_mutex_);
    if (external_goal_received_)
    {
      goal = external_goal_;
    }
    else if (!global_plan_.empty())
    {
      goal = global_plan_.back();
    }
  }

  if (goal.header.frame_id.empty())
  {
    return false;
  }

  if (goal.header.frame_id == costmap_ros_->getGlobalFrameID())
  {
    goal_out = goal;
    return true;
  }

  geometry_msgs::PoseStamped goal_latest = goal;
  // Use latest available transform so map-frame goals are continuously reprojected into odom.
  goal_latest.header.stamp = ros::Time(0);

  geometry_msgs::PoseStamped transformed_goal;
  try
  {
    tf_->transform(goal_latest, transformed_goal, costmap_ros_->getGlobalFrameID(), ros::Duration(0.05));
    goal_out = transformed_goal;
    return true;
  }
  catch (const tf2::TransformException& ex)
  {
    ROS_WARN_THROTTLE(1.0, "SamplingAckermannPlanner: failed to transform goal into %s: %s",
                      costmap_ros_->getGlobalFrameID().c_str(),
                      ex.what());
    return false;
  }
}

bool SamplingAckermannPlanner::hasGoal() const
{
  std::lock_guard<std::mutex> lock(data_mutex_);
  if (use_path_planning_)
  {
    return external_path_received_ || !global_plan_.empty();
  }
  return external_goal_received_ || !global_plan_.empty();
}

bool SamplingAckermannPlanner::resolvePathInCostmapFrame(std::vector<geometry_msgs::PoseStamped>& path_out) const
{
  std::vector<geometry_msgs::PoseStamped> source_path;
  {
    std::lock_guard<std::mutex> lock(data_mutex_);
    if (external_path_received_ && !external_path_.empty())
    {
      source_path = external_path_;
    }
    else if (!global_plan_.empty())
    {
      source_path = global_plan_;
    }
  }

  if (source_path.empty())
  {
    return false;
  }

  path_out.clear();
  path_out.reserve(source_path.size());
  const std::string& target_frame = costmap_ros_->getGlobalFrameID();
  for (const geometry_msgs::PoseStamped& pose : source_path)
  {
    if (pose.header.frame_id.empty())
    {
      continue;
    }

    if (pose.header.frame_id == target_frame)
    {
      path_out.push_back(pose);
      continue;
    }

    geometry_msgs::PoseStamped pose_latest = pose;
    pose_latest.header.stamp = ros::Time(0);

    geometry_msgs::PoseStamped transformed;
    try
    {
      tf_->transform(pose_latest, transformed, target_frame, ros::Duration(0.05));
      path_out.push_back(transformed);
    }
    catch (const tf2::TransformException& ex)
    {
      ROS_WARN_THROTTLE(1.0, "SamplingAckermannPlanner: failed to transform path pose into %s: %s",
                        target_frame.c_str(),
                        ex.what());
      return false;
    }
  }

  return !path_out.empty();
}

geometry_msgs::PoseStamped SamplingAckermannPlanner::selectPathLookaheadGoal(
    const geometry_msgs::PoseStamped& robot_pose,
    const std::vector<geometry_msgs::PoseStamped>& path) const
{
  if (path.empty())
  {
    return geometry_msgs::PoseStamped();
  }

  const size_t nearest_idx = nearestPathIndex(robot_pose, path);
  const double lookahead = std::max(0.0, path_goal_lookahead_distance_);
  if (lookahead < 1e-3 || nearest_idx >= path.size() - 1)
  {
    return path[nearest_idx];
  }

  double accumulated = 0.0;
  for (size_t i = nearest_idx; i + 1 < path.size(); ++i)
  {
    const double segment_dist = distance2D(path[i].pose.position.x,
                                           path[i].pose.position.y,
                                           path[i + 1].pose.position.x,
                                           path[i + 1].pose.position.y);
    accumulated += segment_dist;
    if (accumulated >= lookahead)
    {
      return path[i + 1];
    }
  }

  return path.back();
}

bool SamplingAckermannPlanner::isGoalChanged(const geometry_msgs::PoseStamped& goal) const
{
  std::lock_guard<std::mutex> lock(data_mutex_);

  if (!have_last_goal_)
  {
    return true;
  }

  const double dxy = distance2D(goal.pose.position.x,
                                goal.pose.position.y,
                                last_goal_in_costmap_frame_.pose.position.x,
                                last_goal_in_costmap_frame_.pose.position.y);
  const double yaw = tf2::getYaw(goal.pose.orientation);
  const double last_yaw = tf2::getYaw(last_goal_in_costmap_frame_.pose.orientation);
  const double dyaw = std::abs(normalizeAngle(yaw - last_yaw));
  return dxy > 0.05 || dyaw > 0.05;
}

size_t SamplingAckermannPlanner::nearestPathIndex(const geometry_msgs::PoseStamped& robot_pose,
                                                  const std::vector<geometry_msgs::PoseStamped>& path) const
{
  size_t nearest_idx = 0;
  double best_dist = std::numeric_limits<double>::infinity();
  for (size_t i = 0; i < path.size(); ++i)
  {
    const double d = distance2D(robot_pose.pose.position.x,
                                robot_pose.pose.position.y,
                                path[i].pose.position.x,
                                path[i].pose.position.y);
    if (d < best_dist)
    {
      best_dist = d;
      nearest_idx = i;
    }
  }
  return nearest_idx;
}

void SamplingAckermannPlanner::updateCachedPath(const geometry_msgs::PoseStamped& robot_pose,
                                                const geometry_msgs::PoseStamped& goal,
                                                bool force_full_replan)
{
  (void)force_full_replan;

  RolloutState robot_state{robot_pose.pose.position.x,
                           robot_pose.pose.position.y,
                           tf2::getYaw(robot_pose.pose.orientation)};

  std::lock_guard<std::mutex> lock(data_mutex_);

  // Always make a fresh plan from the current pose at each planning update.
  cached_rollout_path_ = buildRolloutPath(robot_state, goal);
}

std::vector<geometry_msgs::PoseStamped> SamplingAckermannPlanner::buildRolloutPath(const RolloutState& start,
                                                                                   const geometry_msgs::PoseStamped& goal) const
{
  const double initial_dist = distance2D(start.x, start.y, goal.pose.position.x, goal.pose.position.y);
  const double nominal_speed = std::max(std::abs(max_speed_), std::abs(max_reverse_speed_));
  const double segment_span_est = std::max(0.05, nominal_speed * std::max(dt_, 0.01) * std::max(1, rollout_steps_));
  const int required_segments = static_cast<int>(std::ceil(initial_dist / segment_span_est)) + 8;
  const int segment_limit = std::min(500, std::max(max_segments_, required_segments));

  std::vector<geometry_msgs::PoseStamped> path;
  path.reserve(static_cast<size_t>(segment_limit * std::max(1, rollout_steps_) + 2));
  path.push_back(stateToPose(start, ros::Time::now()));

  RolloutState current = start;

  for (int segment = 0; segment < segment_limit; ++segment)
  {
    const double dist_to_goal = distance2D(current.x,
                                           current.y,
                                           goal.pose.position.x,
                                           goal.pose.position.y);
    if (dist_to_goal <= goal_xy_tolerance_)
    {
      break;
    }

    const double goal_heading = std::atan2(goal.pose.position.y - current.y,
                         goal.pose.position.x - current.x);
    const double goal_heading_error = normalizeAngle(goal_heading - current.yaw);
    const bool goal_behind = std::cos(goal_heading_error) < 0.0;
    const bool use_reverse = reverse_enabled_ && goal_behind &&
                 (std::abs(goal_heading_error) > (reverse_heading_threshold_rad_ + 0.5 * forward_priority_bias_));
    const double drive_dir = use_reverse ? -1.0 : 1.0;

    const double segment_time = std::max(dt_, rollout_steps_ * dt_);
    const double max_cmd_speed = use_reverse ? max_reverse_speed_ : max_speed_;
    const double min_cmd_speed = use_reverse ? min_reverse_speed_ : min_speed_;

    double speed_mag = std::min(max_cmd_speed, std::max(min_cmd_speed, dist_to_goal / segment_time));
    speed_mag = std::min(speed_mag, dist_to_goal / std::max(dt_, 0.01));
    const double speed = drive_dir * speed_mag;

    if (!mppi_sampler_)
    {
      break;
    }

    const MPPILinkState mppi_start{current.x, current.y, current.yaw};
    const MPPILinkSampler::SegmentResult best_candidate = mppi_sampler_->sampleBestSegment(mppi_start, goal, speed);

    if (!best_candidate.valid || best_candidate.states.empty())
    {
      break;
    }

    for (const MPPILinkState& st : best_candidate.states)
    {
      RolloutState roll_state;
      roll_state.x = st.x;
      roll_state.y = st.y;
      roll_state.yaw = st.yaw;
      path.push_back(stateToPose(roll_state, ros::Time::now()));
    }

    current.x = best_candidate.states.back().x;
    current.y = best_candidate.states.back().y;
    current.yaw = best_candidate.states.back().yaw;
  }

  const double remaining_dist = distance2D(current.x, current.y, goal.pose.position.x, goal.pose.position.y);
  if (remaining_dist > goal_xy_tolerance_)
  {
    const int line_steps = std::max(1, static_cast<int>(std::ceil(remaining_dist / 0.1)));
    bool clear_to_goal = true;
    for (int i = 1; i <= line_steps; ++i)
    {
      const double a = static_cast<double>(i) / static_cast<double>(line_steps);
      RolloutState probe;
      probe.x = current.x + a * (goal.pose.position.x - current.x);
      probe.y = current.y + a * (goal.pose.position.y - current.y);
      probe.yaw = std::atan2(goal.pose.position.y - current.y, goal.pose.position.x - current.x);
      if (!isStateCollisionFree(probe))
      {
        clear_to_goal = false;
        break;
      }
    }

    if (clear_to_goal)
    {
      const double line_yaw = std::atan2(goal.pose.position.y - current.y, goal.pose.position.x - current.x);
      for (int i = 1; i <= line_steps; ++i)
      {
        const double a = static_cast<double>(i) / static_cast<double>(line_steps);
        RolloutState bridge;
        bridge.x = current.x + a * (goal.pose.position.x - current.x);
        bridge.y = current.y + a * (goal.pose.position.y - current.y);
        bridge.yaw = line_yaw;
        path.push_back(stateToPose(bridge, ros::Time::now()));
      }

      path.push_back(goal);
    }
  }

  optimizePathOnTheFly(path, goal);

  return path;
}

SamplingAckermannPlanner::SegmentCandidate SamplingAckermannPlanner::rolloutSegment(const RolloutState& start,
                                                                                     const geometry_msgs::PoseStamped& goal,
                                                                                     double speed,
                                                                                     double steering) const
{
  SegmentCandidate result;
  result.steering = steering;
  result.score = std::numeric_limits<double>::infinity();
  result.valid = true;

  RolloutState state = start;
  double accumulated_cost = 0.0;

  for (int step = 0; step < rollout_steps_; ++step)
  {
    state.x += speed * std::cos(state.yaw) * dt_;
    state.y += speed * std::sin(state.yaw) * dt_;
    state.yaw = normalizeAngle(state.yaw + (speed / std::max(0.01, wheelbase_)) * std::tan(steering) * dt_);

    if (!isStateCollisionFree(state))
    {
      result.valid = false;
      return result;
    }

    unsigned int mx = 0;
    unsigned int my = 0;
    if (costmap_ros_->getCostmap()->worldToMap(state.x, state.y, mx, my))
    {
      accumulated_cost += static_cast<double>(costmap_ros_->getCostmap()->getCost(mx, my));
    }

    result.states.push_back(state);
  }

  const RolloutState& end = result.states.back();
  const double end_dist = distance2D(end.x, end.y, goal.pose.position.x, goal.pose.position.y);
  const double goal_yaw = tf2::getYaw(goal.pose.orientation);
  const double yaw_err = std::abs(normalizeAngle(goal_yaw - end.yaw));

  result.score = end_dist + 0.4 * yaw_err + obstacle_cost_penalty_ * accumulated_cost;
  return result;
}

bool SamplingAckermannPlanner::isStateCollisionFree(const RolloutState& state) const
{
  unsigned int mx = 0;
  unsigned int my = 0;
  const costmap_2d::Costmap2D* map = costmap_ros_->getCostmap();
  if (!map->worldToMap(state.x, state.y, mx, my))
  {
    return false;
  }

  const unsigned char cost = map->getCost(mx, my);
  if (cost == costmap_2d::NO_INFORMATION)
  {
    return false;
  }
  if (cost >= lethal_cost_threshold_)
  {
    return false;
  }

  return true;
}

bool SamplingAckermannPlanner::isLineCollisionFree(double x0, double y0, double x1, double y1) const
{
  const costmap_2d::Costmap2D* map = costmap_ros_->getCostmap();
  const double map_res = (map && map->getResolution() > 1e-4) ? map->getResolution() : 0.05;
  const double sample_step = std::max(0.02, 0.5 * map_res);

  const double seg_len = distance2D(x0, y0, x1, y1);
  const int checks = std::max(2, static_cast<int>(std::ceil(seg_len / sample_step)));

  for (int i = 0; i <= checks; ++i)
  {
    const double a = static_cast<double>(i) / static_cast<double>(checks);
    RolloutState probe;
    probe.x = x0 + a * (x1 - x0);
    probe.y = y0 + a * (y1 - y0);
    probe.yaw = 0.0;
    if (!isStateCollisionFree(probe))
    {
      return false;
    }
  }

  return true;
}

void SamplingAckermannPlanner::optimizePathOnTheFly(std::vector<geometry_msgs::PoseStamped>& path,
                                                    const geometry_msgs::PoseStamped& goal) const
{
  if (path.size() < 3)
  {
    return;
  }

  // 1) Shortcut pass: remove unnecessary zig-zags when direct visibility exists.
  size_t i = 0;
  while (i + 2 < path.size())
  {
    bool shortcut_found = false;
    for (size_t j = path.size() - 1; j > i + 1; --j)
    {
      const double x0 = path[i].pose.position.x;
      const double y0 = path[i].pose.position.y;
      const double x1 = path[j].pose.position.x;
      const double y1 = path[j].pose.position.y;
      if (isLineCollisionFree(x0, y0, x1, y1))
      {
        path.erase(path.begin() + static_cast<long>(i + 1), path.begin() + static_cast<long>(j));
        shortcut_found = true;
        break;
      }
    }
    if (!shortcut_found)
    {
      ++i;
    }
  }

  if (path.size() < 3)
  {
    return;
  }

  // 2) Local smoothing pass while keeping points collision-free.
  const int smooth_iters = 2;
  for (int it = 0; it < smooth_iters; ++it)
  {
    for (size_t k = 1; k + 1 < path.size(); ++k)
    {
      const double prev_x = path[k - 1].pose.position.x;
      const double prev_y = path[k - 1].pose.position.y;
      const double curr_x = path[k].pose.position.x;
      const double curr_y = path[k].pose.position.y;
      const double next_x = path[k + 1].pose.position.x;
      const double next_y = path[k + 1].pose.position.y;

      const double smooth_x = 0.2 * prev_x + 0.6 * curr_x + 0.2 * next_x;
      const double smooth_y = 0.2 * prev_y + 0.6 * curr_y + 0.2 * next_y;

      RolloutState probe;
      probe.x = smooth_x;
      probe.y = smooth_y;
      probe.yaw = 0.0;
      if (isStateCollisionFree(probe) &&
          isLineCollisionFree(prev_x, prev_y, smooth_x, smooth_y) &&
          isLineCollisionFree(smooth_x, smooth_y, next_x, next_y))
      {
        path[k].pose.position.x = smooth_x;
        path[k].pose.position.y = smooth_y;
      }
    }
  }

  // 3) Endpoint attraction: if tail is still far, pull a few tail points toward goal.
  const size_t tail_idx = path.size() - 1;
  const double tail_dist = distance2D(path[tail_idx].pose.position.x,
                                      path[tail_idx].pose.position.y,
                                      goal.pose.position.x,
                                      goal.pose.position.y);
  if (tail_dist > goal_xy_tolerance_)
  {
    const size_t start_tail = (path.size() > 6) ? path.size() - 6 : 1;
    for (size_t k = start_tail; k < path.size(); ++k)
    {
      const double w = static_cast<double>(k - start_tail + 1) /
                       static_cast<double>(path.size() - start_tail + 1);
      const double target_x = (1.0 - 0.35 * w) * path[k].pose.position.x + (0.35 * w) * goal.pose.position.x;
      const double target_y = (1.0 - 0.35 * w) * path[k].pose.position.y + (0.35 * w) * goal.pose.position.y;

      RolloutState probe;
      probe.x = target_x;
      probe.y = target_y;
      probe.yaw = 0.0;

      const double prev_x = path[k - 1].pose.position.x;
      const double prev_y = path[k - 1].pose.position.y;
      const bool prev_ok = isLineCollisionFree(prev_x, prev_y, target_x, target_y);

      bool next_ok = true;
      if (k + 1 < path.size())
      {
        const double next_x = path[k + 1].pose.position.x;
        const double next_y = path[k + 1].pose.position.y;
        next_ok = isLineCollisionFree(target_x, target_y, next_x, next_y);
      }

      if (isStateCollisionFree(probe) && prev_ok && next_ok)
      {
        path[k].pose.position.x = target_x;
        path[k].pose.position.y = target_y;
      }
    }
  }

  // Refresh orientations from local tangent.
  for (size_t k = 0; k + 1 < path.size(); ++k)
  {
    const double dx = path[k + 1].pose.position.x - path[k].pose.position.x;
    const double dy = path[k + 1].pose.position.y - path[k].pose.position.y;
    const double yaw = std::atan2(dy, dx);
    tf2::Quaternion q;
    q.setRPY(0.0, 0.0, yaw);
    path[k].pose.orientation = tf2::toMsg(q);
  }
  path.back().pose.orientation = goal.pose.orientation;
}

geometry_msgs::PoseStamped SamplingAckermannPlanner::stateToPose(const RolloutState& state, const ros::Time& stamp) const
{
  geometry_msgs::PoseStamped pose;
  pose.header.stamp = stamp;
  pose.header.frame_id = costmap_ros_->getGlobalFrameID();
  pose.pose.position.x = state.x;
  pose.pose.position.y = state.y;
  pose.pose.position.z = 0.0;

  tf2::Quaternion q;
  q.setRPY(0.0, 0.0, state.yaw);
  pose.pose.orientation = tf2::toMsg(q);
  return pose;
}

bool SamplingAckermannPlanner::computePidControl(const geometry_msgs::PoseStamped& robot_pose,
                                                 const std::vector<geometry_msgs::PoseStamped>& path,
                                                 const geometry_msgs::PoseStamped& goal,
                                                 geometry_msgs::Twist& cmd_vel)
{
  if (path.size() < 2)
  {
    return false;
  }

  const double rx = robot_pose.pose.position.x;
  const double ry = robot_pose.pose.position.y;
  const double ryaw = tf2::getYaw(robot_pose.pose.orientation);

  size_t nearest_idx = 0;
  double best_dist = std::numeric_limits<double>::infinity();
  for (size_t i = 0; i < path.size(); ++i)
  {
    const double d = distance2D(rx, ry, path[i].pose.position.x, path[i].pose.position.y);
    if (d < best_dist)
    {
      best_dist = d;
      nearest_idx = i;
    }
  }

  const double dynamic_lookahead = std::max(lookahead_distance_, min_speed_ * 2.0);
  size_t lookahead_idx = nearest_idx;
  for (size_t i = nearest_idx; i < path.size(); ++i)
  {
    const double d = distance2D(rx, ry, path[i].pose.position.x, path[i].pose.position.y);
    if (d >= dynamic_lookahead)
    {
      lookahead_idx = i;
      break;
    }
    lookahead_idx = i;
  }

  const geometry_msgs::PoseStamped& path_target = path[lookahead_idx];
  const double goal_heading = std::atan2(goal.pose.position.y - ry, goal.pose.position.x - rx);
  const double goal_heading_error = normalizeAngle(goal_heading - ryaw);

  const bool goal_behind = std::cos(goal_heading_error) < 0.0;
  const double reverse_entry_threshold = reverse_heading_threshold_rad_ + forward_priority_bias_;
  const double reverse_release_threshold = std::max(0.2, reverse_release_heading_threshold_rad_);

  if (reverse_enabled_)
  {
    if (reverse_mode_latched_)
    {
      if (!goal_behind || std::abs(goal_heading_error) < reverse_release_threshold)
      {
        reverse_mode_latched_ = false;
      }
    }
    else
    {
      if (goal_behind && std::abs(goal_heading_error) > reverse_entry_threshold)
      {
        reverse_mode_latched_ = true;
      }
    }
  }
  else
  {
    reverse_mode_latched_ = false;
  }

  const bool allow_reverse = reverse_mode_latched_;
  const double drive_dir = allow_reverse ? -1.0 : 1.0;
  const double control_goal_heading_error = normalizeAngle(goal_heading - ((drive_dir < 0.0) ? normalizeAngle(ryaw + M_PI) : ryaw));

  const geometry_msgs::PoseStamped& target = path_target;
  const double tx = target.pose.position.x;
  const double ty = target.pose.position.y;

  const double control_yaw = (drive_dir < 0.0) ? normalizeAngle(ryaw + M_PI) : ryaw;
  const double target_heading = std::atan2(ty - ry, tx - rx);
  const double heading_error = normalizeAngle(target_heading - control_yaw);

  const double dx = tx - rx;
  const double dy = ty - ry;
  const double cross_track_error = -std::sin(control_yaw) * dx + std::cos(control_yaw) * dy;

  heading_integral_ += heading_error * dt_;
  heading_integral_ = std::max(-pid_integral_limit_, std::min(pid_integral_limit_, heading_integral_));

  double heading_derivative = 0.0;
  if (has_last_heading_error_)
  {
    heading_derivative = (heading_error - last_heading_error_) / std::max(dt_, 1e-3);
  }
  last_heading_error_ = heading_error;
  has_last_heading_error_ = true;

  double steering_cmd = pid_kp_ * heading_error +
                        pid_ki_ * heading_integral_ +
                        pid_kd_ * heading_derivative +
                        pid_cte_kp_ * cross_track_error;
  steering_cmd = std::max(-max_steering_rad_, std::min(max_steering_rad_, steering_cmd));

  const double dist_to_goal = distance2D(rx, ry, goal.pose.position.x, goal.pose.position.y);
  const double stop_dist = goal_xy_tolerance_ + std::max(0.0, goal_stop_buffer_);
  const double slow_down_dist = std::max(stop_dist * 3.0, 0.6);

  const double max_cmd_speed = (drive_dir < 0.0) ? max_reverse_speed_ : max_speed_;
  const double min_cmd_speed = (drive_dir < 0.0) ? min_reverse_speed_ : min_speed_;

  double speed = max_cmd_speed;
  if (dist_to_goal < slow_down_dist)
  {
    speed = max_cmd_speed * (dist_to_goal / std::max(0.01, slow_down_dist));
  }
  else
  {
    speed = std::max(min_cmd_speed, speed);
  }

  // Prevent overrun: do not command a step that would cross past goal tolerance in one cycle.
  const double overrun_limit = std::max(0.0, (dist_to_goal - stop_dist) / std::max(dt_, 0.01));
  const double speed_mag = std::max(0.0, std::min(speed, overrun_limit));
  cmd_vel.linear.x = drive_dir * speed_mag;

  double steering_norm = steering_cmd / std::max(1e-3, max_steering_rad_);
  if (std::abs(steering_norm) < min_steering_norm_cmd_ &&
      std::abs(heading_error) > heading_turn_threshold_rad_)
  {
    const double steer_sign = (control_goal_heading_error >= 0.0) ? 1.0 : -1.0;
    steering_norm = steer_sign * min_steering_norm_cmd_;
  }

  cmd_vel.angular.z = std::max(-1.0, std::min(1.0, steering_norm));

  if (dist_to_goal <= stop_dist)
  {
    cmd_vel.linear.x = 0.0;
    cmd_vel.angular.z = 0.0;
  }

  return true;
}

double SamplingAckermannPlanner::normalizeAngle(double a)
{
  while (a > M_PI)
  {
    a -= 2.0 * M_PI;
  }
  while (a < -M_PI)
  {
    a += 2.0 * M_PI;
  }
  return a;
}

double SamplingAckermannPlanner::distance2D(double x0, double y0, double x1, double y1)
{
  const double dx = x1 - x0;
  const double dy = y1 - y0;
  return std::sqrt(dx * dx + dy * dy);
}
}  // namespace rtx_navigation

PLUGINLIB_EXPORT_CLASS(rtx_navigation::SamplingAckermannPlanner, nav_core::BaseLocalPlanner)
