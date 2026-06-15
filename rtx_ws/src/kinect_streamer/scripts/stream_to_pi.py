#!/usr/bin/env python3
import rospy
import subprocess
import numpy as np
from sensor_msgs.msg import Image
from cv_bridge import CvBridge

PI_IP = "192.168.1.50"
PORT  = 5000

bridge = CvBridge()
proc   = None

def start_pipeline():
    cmd = [
        "ffmpeg",
        "-f", "rawvideo",
        "-pix_fmt", "bgr24",
        "-s", "640x480",
        "-r", "15",
        "-i", "pipe:0",
        "-f", "rtp",
        "-vcodec", "libx264",
        "-tune", "zerolatency",
        "-preset", "ultrafast",
        "-b:v", "2000k",
        f"rtp://{PI_IP}:{PORT}"
    ]
    return subprocess.Popen(cmd, stdin=subprocess.PIPE)

def image_cb(msg):
    global proc
    if proc is None or proc.poll() is not None:
        rospy.loginfo("Starting ffmpeg pipeline...")
        proc = start_pipeline()

    frame = bridge.imgmsg_to_cv2(msg, "bgr8")
    import cv2
    frame = cv2.resize(frame, (640, 480))
    try:
        proc.stdin.write(frame.tobytes())
        proc.stdin.flush()
    except BrokenPipeError:
        rospy.logwarn("Pipeline broke, restarting...")
        proc = None

rospy.init_node("kinect_streamer")
rospy.Subscriber("/rgb/image_raw", Image, image_cb, queue_size=1)
rospy.loginfo(f"Kinect streamer started — sending to {PI_IP}:{PORT}")
rospy.spin()
