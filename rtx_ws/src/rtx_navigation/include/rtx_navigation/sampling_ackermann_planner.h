#ifndef RTX_NAVIGATION_SAMPLING_ACKERMANN_PLANNER_H_
#define RTX_NAVIGATION_SAMPLING_ACKERMANN_PLANNER_H_

#include <mutex>
#include <memory>
#include <string>
#include <vector>

#include <costmap_2d/costmap_2d_ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <geometry_msgs/Twist.h>
#include <nav_core/base_local_planner.h>
#include <nav_msgs/Path.h>
#include <ros/ros.h>
#include <tf2_ros/buffer.h>

#include <rtx_navigation/mppi_link_sampler.h>

namespace rtx_navigation
{
class SamplingAckermannPlanner : public nav_core::BaseLocalPlanner
{
public:
  SamplingAckermannPlanner();
  ~SamplingAckermannPlanner() override = default;

  void initialize(std::string name, tf2_ros::Buffer* tf, costmap_2d::Costmap2DROS* costmap_ros) override;
  bool setPlan(const std::vector<geometry_msgs::PoseStamped>& orig_global_plan) override;
  bool computeVelocityCommands(geometry_msgs::Twist& cmd_vel) override;
  bool isGoalReached() override;

private:
  struct RolloutState
  {
    double x;
    double y;
    double yaw;
  };

  struct SegmentCandidate
  {
    std::vector<RolloutState> states;
    double steering;
    double score;
    bool valid;
  };

  void goalCallback(const geometry_msgs::PoseStamped::ConstPtr& msg);
  void pathCallback(const nav_msgs::Path::ConstPtr& msg);
  bool resolveGoalInCostmapFrame(geometry_msgs::PoseStamped& goal_out);
  bool resolvePathInCostmapFrame(std::vector<geometry_msgs::PoseStamped>& path_out) const;
  geometry_msgs::PoseStamped selectPathLookaheadGoal(const geometry_msgs::PoseStamped& robot_pose,
                                                     const std::vector<geometry_msgs::PoseStamped>& path) const;
  bool hasGoal() const;
  bool isGoalChanged(const geometry_msgs::PoseStamped& goal) const;

  void updateCachedPath(const geometry_msgs::PoseStamped& robot_pose,
                        const geometry_msgs::PoseStamped& goal,
                        bool force_full_replan);

  size_t nearestPathIndex(const geometry_msgs::PoseStamped& robot_pose,
                          const std::vector<geometry_msgs::PoseStamped>& path) const;

  std::vector<geometry_msgs::PoseStamped> buildRolloutPath(const RolloutState& start,
                                                           const geometry_msgs::PoseStamped& goal) const;

  SegmentCandidate rolloutSegment(const RolloutState& start,
                                  const geometry_msgs::PoseStamped& goal,
                                  double speed,
                                  double steering) const;

  bool isStateCollisionFree(const RolloutState& state) const;
  bool isLineCollisionFree(double x0, double y0, double x1, double y1) const;
  void optimizePathOnTheFly(std::vector<geometry_msgs::PoseStamped>& path,
                            const geometry_msgs::PoseStamped& goal) const;
  geometry_msgs::PoseStamped stateToPose(const RolloutState& state, const ros::Time& stamp) const;

  bool computePidControl(const geometry_msgs::PoseStamped& robot_pose,
                         const std::vector<geometry_msgs::PoseStamped>& path,
                         const geometry_msgs::PoseStamped& goal,
                         geometry_msgs::Twist& cmd_vel);

  static double normalizeAngle(double a);
  static double distance2D(double x0, double y0, double x1, double y1);

  bool initialized_;
  bool goal_reached_;

  tf2_ros::Buffer* tf_;
  costmap_2d::Costmap2DROS* costmap_ros_;
  ros::NodeHandle nh_;
  ros::Subscriber goal_sub_rviz_;
  ros::Subscriber goal_sub_nav_;
  ros::Subscriber path_sub_nav_;
  ros::Publisher path_pub_;

  mutable std::mutex data_mutex_;
  std::vector<geometry_msgs::PoseStamped> global_plan_;
  geometry_msgs::PoseStamped external_goal_;
  bool external_goal_received_;
  std::vector<geometry_msgs::PoseStamped> external_path_;
  bool external_path_received_;
  std::vector<geometry_msgs::PoseStamped> cached_rollout_path_;
  geometry_msgs::PoseStamped last_goal_in_costmap_frame_;
  bool have_last_goal_;
  ros::Time last_plan_time_;

  // Vehicle and rollout parameters
  double wheelbase_;
  double track_width_;
  double dt_;
  double planning_frequency_;
  int incremental_segments_;
  double replan_deviation_threshold_;
  int rollout_steps_;
  int max_segments_;
  int steering_samples_;
  int mppi_num_rollouts_;
  double max_steering_rad_;
  double max_speed_;
  double min_speed_;
  double mppi_noise_sigma_rad_;
  double mppi_temperature_;
  double mppi_control_weight_;
  double mppi_progress_weight_;
  double mppi_terminal_weight_;
  bool reverse_enabled_;
  double max_reverse_speed_;
  double min_reverse_speed_;
  double reverse_heading_threshold_rad_;
  double reverse_release_heading_threshold_rad_;
  double forward_priority_bias_;
  bool use_path_planning_;
  double lookahead_distance_;
  double path_goal_lookahead_distance_;
  double min_steering_norm_cmd_;
  double heading_turn_threshold_rad_;
  double goal_stop_buffer_;
  double goal_xy_tolerance_;
  double goal_yaw_tolerance_;
  bool enable_final_reorientation_;
  double final_reorient_speed_;
  double final_reorient_steering_norm_;
  double obstacle_cost_penalty_;
  unsigned char lethal_cost_threshold_;

  // PID gains for steering command
  double pid_kp_;
  double pid_ki_;
  double pid_kd_;
  double pid_cte_kp_;
  double pid_integral_limit_;

  // PID state
  double heading_integral_;
  double last_heading_error_;
  bool has_last_heading_error_;
  double last_dist_to_goal_;
  bool have_last_dist_to_goal_;
  bool reverse_mode_latched_;

  std::unique_ptr<MPPILinkSampler> mppi_sampler_;
};
}  // namespace rtx_navigation

#endif  // RTX_NAVIGATION_SAMPLING_ACKERMANN_PLANNER_H_
