# UGV GPS-Denied Navigation

ROS Noetic stack for an Ackermann-drive UGV that navigates autonomously in GPS-denied environments. Localization is provided by LiDAR-inertial odometry (DLIO). Navigation goals are received from a coordinating UAV over WebSocket, based on ArUco tag detections. Obstacle perception is handled by an Azure Kinect depth camera, with depth frames offloaded to a Raspberry Pi running a BrainChip Akida neuromorphic chip for occupancy inference.

## System Architecture

```
UAV (WebSocket server)
  └── tag_goal_sender.py  ──► move_base ──► Ackermann costmap planner
                                               └── cmd_vel_bridge.py ──► Teensy (rosserial)

Azure Kinect ──► depth_to_grid.py ──UDP──► Raspberry Pi (Akida)
             └── dlio ──► /odom (LiDAR-inertial odometry)
             └── AMCL  ──► /map frame

ldlidar (LD06/LD19) ──► DLIO ──► localization
```

## Hardware

- **Compute**: NVIDIA Jetson
- **Depth / IMU**: Microsoft Azure Kinect
- **LiDAR**: LD06 or LD19 (ldlidar)
- **Motor controller**: Teensy (rosserial, `/dev/teensy`, 57600 baud)
- **Neuromorphic inference**: Raspberry Pi + BrainChip Akida chip (receives depth grid over UDP)

## ROS Packages

| Package | Description |
|---|---|
| `ugv_bringup` | Top-level bringup: Teensy serial, cmd_vel bridge, mission logger, ArUco tag goal sender |
| `rtx_description` | Robot URDF |
| `rtx_navigation` | AMCL, move_base, custom Ackermann MPPI sampler planner |
| `ugv_control` | Ackermann costmap local planner |
| `akida_perception` | Converts Kinect depth frames to occupancy grids and sends to Pi over UDP |
| `kinect_streamer` | Streams Kinect RGB video to Pi via ffmpeg/RTP |
| `dlio` | Direct LiDAR-Inertial Odometry for GPS-denied localization |
| `ldlidar_stl_ros` | ROS driver for LD06 / LD19 LiDARs |
| `Azure_Kinect_ROS_Driver` | ROS driver for the Azure Kinect |

## UAV–UGV Coordination

`tag_goal_sender.py` connects to the UAV's WebSocket server (`ws://10.42.0.99:9090`) and listens for ArUco tag detections. When a target tag (default `id=0`) is detected, its map coordinates are forwarded as a `move_base` goal. The UAV broadcasts a `search_start` event at the beginning of each run containing its starting position, which is used to align the two robots' coordinate frames.

## Setup

### udev Rules

```bash
sudo cp rules.d/* /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger
```

### Build

```bash
cd rtx_ws
catkin_make
source devel/setup.bash
```

### Dependencies

```bash
# Core
sudo apt install ros-noetic-rosserial-python ros-noetic-move-base \
    ros-noetic-amcl ros-noetic-imu-filter-madgwick

# LiDAR / perception
sudo apt install libomp-dev libpcl-dev libeigen3-dev

# Kinect streamer
sudo apt install ffmpeg
```

Azure Kinect SDK (k4a) must be installed separately — see `Azure_Kinect_ROS_Driver/README.md`.

## Running

Bring up the robot (Teensy + cmd_vel bridge):

```bash
roslaunch ugv_bringup bringup.launch
```

Start localization (DLIO + AMCL):

```bash
roslaunch dlio slam.launch
```

Start navigation (move_base + planner):

```bash
roslaunch rtx_navigation move_base.launch
```

Start perception and UAV goal receiver:

```bash
roslaunch akida_perception akida_full.launch
rosrun ugv_bringup tag_goal_sender.py
```

Mission logs are written to `~/.ros/mission_logs/` as newline-delimited JSON.
