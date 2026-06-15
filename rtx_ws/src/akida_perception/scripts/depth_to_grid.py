#!/usr/bin/env python3
import rospy
import socket
import numpy as np
from sensor_msgs.msg import Image
from cv_bridge import CvBridge

PI_IP      = "192.168.1.16"
PI_PORT    = 5000          # Pi listens for depth grid on this port
GRID_SIZE  = 60
MAX_RANGE  = 5000          # mm — ignore anything beyond 5 metres
MIN_RANGE  = 200           # mm — ignore anything closer than 20cm (noise)

bridge = CvBridge()
sock   = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

def depth_cb(msg):
    # Convert ROS depth image to numpy array (values in mm)
    depth = bridge.imgmsg_to_cv2(msg, desired_encoding="passthrough")
    depth = np.array(depth, dtype=np.float32)

    h, w = depth.shape

    # Mask out invalid readings
    valid = (depth > MIN_RANGE) & (depth < MAX_RANGE)
    depth[~valid] = 0

    # Bin the depth image into the occupancy grid
    grid = np.zeros((GRID_SIZE, GRID_SIZE), dtype=np.uint8)

    # Each grid cell covers a region of the depth image
    cell_h = h // GRID_SIZE
    cell_w = w // GRID_SIZE

    for row in range(GRID_SIZE):
        for col in range(GRID_SIZE):
            patch = depth[
                row * cell_h:(row + 1) * cell_h,
                col * cell_w:(col + 1) * cell_w
            ]
            # If any valid depth reading exists in this cell, mark as occupied
            if np.any(patch > 0):
                grid[row, col] = 1

    # Send raw grid bytes to Pi
    sock.sendto(grid.tobytes(), (PI_IP, PI_PORT))

rospy.init_node("depth_to_grid")
rospy.Subscriber("/depth_to_rgb/image_raw", Image, depth_cb, queue_size=1)
rospy.loginfo(f"Depth to grid node started — sending to {PI_IP}:{PI_PORT}")
rospy.spin()

sock.close()
