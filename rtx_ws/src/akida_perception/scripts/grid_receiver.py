#!/usr/bin/env python3
import socket
import numpy as np
import rospy
import sensor_msgs.point_cloud2 as pc2
from sensor_msgs.msg import PointCloud2, PointField
from std_msgs.msg import Header

GRID_SIZE   = 60
CELL_SIZE_M = 0.15   # Pi uses 0.5 ft ≈ 0.152 m per cell
PORT        = 5005
OBS_HEIGHT  = 0.5    # publish points at 0.5 m height so costmap registers them

rospy.init_node("akida_grid_receiver")
pub = rospy.Publisher("/akida/obstacles", PointCloud2, queue_size=1)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("0.0.0.0", PORT))
sock.settimeout(1.0)

half = GRID_SIZE * CELL_SIZE_M / 2.0  # lateral offset to center grid on robot

rospy.loginfo(f"Listening for Akida obstacle grid on UDP:{PORT}")

while not rospy.is_shutdown():
    try:
        data, _ = sock.recvfrom(GRID_SIZE * GRID_SIZE + 64)
    except socket.timeout:
        continue

    grid_np = np.frombuffer(data[:GRID_SIZE * GRID_SIZE], dtype=np.uint8)
    if grid_np.size != GRID_SIZE * GRID_SIZE:
        continue

    grid_2d = grid_np.reshape((GRID_SIZE, GRID_SIZE))

    # Convert each occupied cell to a 3D point in base_link frame
    rows, cols = np.where(grid_2d > 0)
    points = []
    for r, c in zip(rows, cols):
        x = c * CELL_SIZE_M            # forward (image col → lateral is wrong but best we have)
        y = r * CELL_SIZE_M - half     # centered laterally
        points.append([x, y, OBS_HEIGHT])

    header = Header()
    header.stamp    = rospy.Time.now()
    header.frame_id = "base_link"

    cloud = pc2.create_cloud_xyz32(header, points)
    pub.publish(cloud)

sock.close()
