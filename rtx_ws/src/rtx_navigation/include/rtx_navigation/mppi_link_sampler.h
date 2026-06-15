#ifndef RTX_NAVIGATION_MPPI_LINK_SAMPLER_H_
#define RTX_NAVIGATION_MPPI_LINK_SAMPLER_H_

#include <random>
#include <vector>

#include <costmap_2d/costmap_2d.h>
#include <geometry_msgs/PoseStamped.h>

namespace rtx_navigation
{
struct MPPILinkState
{
  double x;
  double y;
  double yaw;
};

class MPPILinkSampler
{
public:
  struct Params
  {
    double wheelbase;
    double dt;
    int rollout_steps;
    int num_rollouts;
    double max_steering_rad;
    double noise_sigma_rad;
    double temperature;
    double control_weight;
    double progress_weight;
    double terminal_weight;
    double obstacle_cost_penalty;
    unsigned char lethal_cost_threshold;
  };

  struct SegmentResult
  {
    std::vector<MPPILinkState> states;
    std::vector<double> steering;
    bool valid;
    double cost;
  };

  MPPILinkSampler(const costmap_2d::Costmap2D* costmap, const Params& params);

  void setCostmap(const costmap_2d::Costmap2D* costmap);
  void setParams(const Params& params);

  SegmentResult sampleBestSegment(const MPPILinkState& start,
                                  const geometry_msgs::PoseStamped& goal,
                                  double speed) const;

private:
  static double normalizeAngle(double a);
  static double distance2D(double x0, double y0, double x1, double y1);

  bool isStateCollisionFree(const MPPILinkState& state, double* cell_cost) const;

  MPPILinkState propagate(const MPPILinkState& state, double speed, double steering) const;

  const costmap_2d::Costmap2D* costmap_;
  Params params_;

  mutable std::mt19937 rng_;
};
}  // namespace rtx_navigation

#endif  // RTX_NAVIGATION_MPPI_LINK_SAMPLER_H_
