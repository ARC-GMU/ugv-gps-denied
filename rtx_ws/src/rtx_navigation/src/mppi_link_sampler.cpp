#include <rtx_navigation/mppi_link_sampler.h>

#include <algorithm>
#include <cmath>
#include <limits>

#include <costmap_2d/cost_values.h>
#include <tf2/utils.h>

namespace rtx_navigation
{
MPPILinkSampler::MPPILinkSampler(const costmap_2d::Costmap2D* costmap, const Params& params)
  : costmap_(costmap)
  , params_(params)
  , rng_(std::random_device{}())
{
}

void MPPILinkSampler::setCostmap(const costmap_2d::Costmap2D* costmap)
{
  costmap_ = costmap;
}

void MPPILinkSampler::setParams(const Params& params)
{
  params_ = params;
}

MPPILinkSampler::SegmentResult MPPILinkSampler::sampleBestSegment(const MPPILinkState& start,
                                                                  const geometry_msgs::PoseStamped& goal,
                                                                  double speed) const
{
  SegmentResult result;
  result.valid = false;
  result.cost = std::numeric_limits<double>::infinity();

  if (!costmap_ || params_.rollout_steps <= 0 || params_.num_rollouts <= 0)
  {
    return result;
  }

  const int steps = params_.rollout_steps;
  const int rollouts = params_.num_rollouts;
  const double goal_yaw = tf2::getYaw(goal.pose.orientation);
  const double temperature = std::max(1e-3, params_.temperature);
  const double sigma = std::max(1e-4, params_.noise_sigma_rad);

  std::normal_distribution<double> noise_dist(0.0, sigma);

  std::vector<std::vector<double>> controls;
  std::vector<std::vector<MPPILinkState>> trajectories;
  std::vector<double> costs;
  controls.reserve(static_cast<size_t>(rollouts));
  trajectories.reserve(static_cast<size_t>(rollouts));
  costs.reserve(static_cast<size_t>(rollouts));

  std::vector<double> nominal_controls(static_cast<size_t>(steps), 0.0);

  for (int k = 0; k < rollouts; ++k)
  {
    std::vector<double> rollout_controls(static_cast<size_t>(steps), 0.0);
    std::vector<MPPILinkState> rollout_states;
    rollout_states.reserve(static_cast<size_t>(steps));

    MPPILinkState state = start;
    double total_cost = 0.0;
    bool valid = true;

    for (int t = 0; t < steps; ++t)
    {
      const double steer = std::max(-params_.max_steering_rad,
                                    std::min(params_.max_steering_rad,
                                             nominal_controls[static_cast<size_t>(t)] + noise_dist(rng_)));
      rollout_controls[static_cast<size_t>(t)] = steer;

      state = propagate(state, speed, steer);

      double cell_cost = 0.0;
      if (!isStateCollisionFree(state, &cell_cost))
      {
        valid = false;
        break;
      }

      const double d_goal = distance2D(state.x, state.y, goal.pose.position.x, goal.pose.position.y);
      total_cost += params_.progress_weight * d_goal;
      total_cost += params_.control_weight * steer * steer;
      total_cost += params_.obstacle_cost_penalty * cell_cost;

      rollout_states.push_back(state);
    }

    if (!valid || rollout_states.empty())
    {
      continue;
    }

    const MPPILinkState& end = rollout_states.back();
    const double terminal_dist = distance2D(end.x, end.y, goal.pose.position.x, goal.pose.position.y);
    const double terminal_yaw = std::abs(normalizeAngle(goal_yaw - end.yaw));
    total_cost += params_.terminal_weight * (terminal_dist + 0.35 * terminal_yaw);

    controls.push_back(rollout_controls);
    trajectories.push_back(rollout_states);
    costs.push_back(total_cost);

    if (total_cost < result.cost)
    {
      result.cost = total_cost;
      result.valid = true;
      result.states = rollout_states;
      result.steering = rollout_controls;
    }
  }

  if (!result.valid || costs.empty())
  {
    return result;
  }

  double min_cost = std::numeric_limits<double>::infinity();
  for (double c : costs)
  {
    min_cost = std::min(min_cost, c);
  }

  std::vector<double> blended_controls(static_cast<size_t>(steps), 0.0);
  double weight_sum = 0.0;
  for (size_t i = 0; i < costs.size(); ++i)
  {
    const double w = std::exp(-(costs[i] - min_cost) / temperature);
    weight_sum += w;
    for (int t = 0; t < steps; ++t)
    {
      blended_controls[static_cast<size_t>(t)] += w * controls[i][static_cast<size_t>(t)];
    }
  }

  if (weight_sum <= 1e-9)
  {
    return result;
  }

  for (double& u : blended_controls)
  {
    u /= weight_sum;
    u = std::max(-params_.max_steering_rad, std::min(params_.max_steering_rad, u));
  }

  SegmentResult blended;
  blended.valid = true;
  blended.cost = 0.0;
  blended.steering = blended_controls;
  blended.states.reserve(static_cast<size_t>(steps));

  MPPILinkState state = start;
  for (int t = 0; t < steps; ++t)
  {
    state = propagate(state, speed, blended_controls[static_cast<size_t>(t)]);
    double cell_cost = 0.0;
    if (!isStateCollisionFree(state, &cell_cost))
    {
      blended.valid = false;
      break;
    }
    blended.states.push_back(state);
    const double d_goal = distance2D(state.x, state.y, goal.pose.position.x, goal.pose.position.y);
    blended.cost += params_.progress_weight * d_goal +
                    params_.control_weight * blended_controls[static_cast<size_t>(t)] * blended_controls[static_cast<size_t>(t)] +
                    params_.obstacle_cost_penalty * cell_cost;
  }

  if (!blended.valid || blended.states.empty())
  {
    return result;
  }

  const MPPILinkState& end = blended.states.back();
  blended.cost += params_.terminal_weight *
                  (distance2D(end.x, end.y, goal.pose.position.x, goal.pose.position.y) +
                   0.35 * std::abs(normalizeAngle(goal_yaw - end.yaw)));

  if (blended.cost < result.cost)
  {
    return blended;
  }

  return result;
}

bool MPPILinkSampler::isStateCollisionFree(const MPPILinkState& state, double* cell_cost) const
{
  if (!costmap_)
  {
    return false;
  }

  unsigned int mx = 0;
  unsigned int my = 0;
  if (!costmap_->worldToMap(state.x, state.y, mx, my))
  {
    if (cell_cost)
    {
      *cell_cost = 0.0;
    }
    return true;
  }

  const unsigned char cost = costmap_->getCost(mx, my);
  if (cell_cost)
  {
    *cell_cost = static_cast<double>(cost);
  }

  if (cost == costmap_2d::NO_INFORMATION)
  {
    return false;
  }

  if (cost >= params_.lethal_cost_threshold)
  {
    return false;
  }

  return true;
}

MPPILinkState MPPILinkSampler::propagate(const MPPILinkState& state, double speed, double steering) const
{
  MPPILinkState next = state;
  next.x += speed * std::cos(state.yaw) * params_.dt;
  next.y += speed * std::sin(state.yaw) * params_.dt;
  next.yaw = normalizeAngle(state.yaw + (speed / std::max(0.01, params_.wheelbase)) * std::tan(steering) * params_.dt);
  return next;
}

double MPPILinkSampler::normalizeAngle(double a)
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

double MPPILinkSampler::distance2D(double x0, double y0, double x1, double y1)
{
  const double dx = x1 - x0;
  const double dy = y1 - y0;
  return std::sqrt(dx * dx + dy * dy);
}
}  // namespace rtx_navigation
