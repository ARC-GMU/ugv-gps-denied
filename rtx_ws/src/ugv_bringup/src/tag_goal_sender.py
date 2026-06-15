#!/usr/bin/env python3
# import requests
import websocket
import threading
import json
import time
import sys
import rospy
import actionlib
import tf
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal
from geometry_msgs.msg import PoseStamped

# HTTP version
# URL = "http://10.42.0.99:8000/api/aruco_tags"
# WebSocket version
WS_URL = "ws://10.42.0.99:9090"

# INTERVAL = 1.0  # seconds — not needed with websockets, server pushes updates
TARGET_TAG_ID = 0  # change to whichever tag ID you want to follow



def send_goal(client, goal_pub, x, y, yaw=0.0, goal_sent=False):

    q = tf.transformations.quaternion_from_euler(0, 0, yaw)

    pose_msg = PoseStamped()
    pose_msg.header.frame_id = "odom"
    pose_msg.header.stamp = rospy.Time.now()
    pose_msg.pose.position.x = x
    pose_msg.pose.position.y = y
    pose_msg.pose.position.z = 0.0
    pose_msg.pose.orientation.x = q[0]
    pose_msg.pose.orientation.y = q[1]
    pose_msg.pose.orientation.z = q[2]
    pose_msg.pose.orientation.w = q[3]
    goal_pub.publish(pose_msg)
    rospy.loginfo(f"pose: {pose_msg}")

    # Send without waiting — so we can keep updating the goal as position changes
    goal = MoveBaseGoal()
    goal.target_pose = pose_msg
    client.send_goal(goal)

# ── HTTP polling version (kept for reference) ──────────────────────────────────
# def poll(url: str, interval: float) -> None:
#     rospy.init_node("tag_goal_sender")
#     url = rospy.get_param("~url", "http://10.42.0.99:8000/api/aruco_tags")
#     client = actionlib.SimpleActionClient("move_base", MoveBaseAction)
#     rospy.loginfo("Waiting for move_base action server...")
#     client.wait_for_server()
#     rospy.loginfo("Connected to move_base")
#     session = requests.Session()
#     last_goal = None
#     print(f"Polling {url} every {interval}s — press Ctrl+C to stop\n")
#     while not rospy.is_shutdown():
#         try:
#             response = session.get(url, timeout=10)
#             response.raise_for_status()
#             if not response.text.strip():
#                 rospy.logwarn(f"Empty response from {url}")
#                 time.sleep(interval)
#                 continue
#             data = response.json()
#             tags = data.get("tags", [])
#             target = next((t for t in tags if t["id"] == TARGET_TAG_ID), None)
#             if target is None:
#                 rospy.logwarn(f"Tag {TARGET_TAG_ID} not found in response")
#             else:
#                 map_x = target["map_x"]
#                 map_y = target["map_y"]
#                 ts    = target["ts"]
#                 if last_goal is None or abs(map_x - last_goal[0]) > 0.1 or abs(map_y - last_goal[1]) > 0.1:
#                     rospy.loginfo(f"New goal — map_x: {map_x:.2f} map_y: {map_y:.2f} (tag ts: {ts})")
#                     send_goal(client, map_x, map_y)
#                     last_goal = (map_x, map_y)
#                 else:
#                     rospy.logdebug("Position unchanged, skipping goal update")
#         except requests.exceptions.RequestException as e:
#             rospy.logerr(f"HTTP error: {e}")
#         except (KeyError, ValueError) as e:
#             rospy.logerr(f"Parse error: {e}")
#         time.sleep(interval)

# ── WebSocket version ──────────────────────────────────────────────────────────

def run(ws_url: str) -> None:
    rospy.init_node("tag_goal_sender")
    ws_url = rospy.get_param("~url", ws_url)

    client = actionlib.SimpleActionClient("move_base", MoveBaseAction)
    rospy.loginfo("Waiting for move_base action server...")
    client.wait_for_server()
    rospy.loginfo("Connected to move_base")

    last_goal  = [None]  # list so nested callbacks can mutate
    uav_origin = [None]  # set from search_start.start_x/y — offsets map coords to shared (0,0)
    goal_pub = rospy.Publisher("/move_base_simple/goal", PoseStamped, queue_size=1)


    def on_message(ws, message):
        try:
            msg  = json.loads(message)
            kind = msg.get("type")
            data = msg.get("data", {})

            # search_start fires once when the test begins and includes the UAV's
            # starting position in map frame — use this as the origin offset so
            # the UGV's (0,0) always matches regardless of where the run starts
            if kind == "search_start":
                uav_origin[0] = (data["start_x"], data["start_y"])
                rospy.loginfo(f"Origin set from search_start: {uav_origin[0]}")
                return

            if kind != "aruco_tag":
                return  # ignore mavros_state, vio_odom, camera_frame, rosout, etc.
            rospy.logwarn(data.get("id"))
            if data.get("id") != TARGET_TAG_ID:
                rospy.logdebug(f"Ignoring tag id {data.get('id')}")
                return

            if "x" not in data or "y" not in data:
                rospy.logwarn(data)
                rospy.logwarn("aruco_tag missing x/y — RTAB map not available yet")
                return

            origin_x, origin_y = uav_origin[0] if uav_origin[0] else (0.0, 0.0)

            # Subtract UAV start position so goal is in UGV's coordinate frame
            map_x = data["y"] + 2.0# - origin_x
            map_y = -data["x"] - 1.0 # - origin_y
            ts    = data["ts"]
            rospy.loginfo(f"x: {map_x:.2f} y: {map_y:.2f} (tag ts: {ts})")
            if (last_goal[0] is None
                    or abs(map_x - last_goal[0][0]) > 0.1
                    or abs(map_y - last_goal[0][1]) > 0.1):
                rospy.loginfo(f"New goal — x: {map_x:.2f} y: {map_y:.2f} (tag ts: {ts})")
                send_goal(client, goal_pub, map_x, map_y)
                last_goal[0] = (map_x, map_y)
            else:
                rospy.logdebug("Position unchanged, skipping goal update")

        except (KeyError, ValueError, json.JSONDecodeError) as e:
            rospy.logerr(f"Parse error: {e}")

    def on_error(ws, error):
        rospy.logerr(f"WebSocket error: {error}")

    def on_close(ws, close_status_code, close_msg):
        rospy.logwarn(f"WebSocket closed ({close_status_code}): {close_msg}")

    def on_open(ws):
        rospy.loginfo(f"WebSocket connected to {ws_url}")

    def ws_thread():
        while not rospy.is_shutdown():
            try:
                ws = websocket.WebSocketApp(
                    ws_url,
                    on_message=on_message,
                    on_error=on_error,
                    on_close=on_close,
                    on_open=on_open,
                )
                ws.run_forever(ping_interval=20, ping_timeout=10)
            except Exception as e:
                rospy.logerr(f"WebSocket exception: {e}")
            if not rospy.is_shutdown():
                rospy.loginfo("WebSocket reconnecting in 3s...")
                time.sleep(0.5)

    # Run WebSocket in background thread, ROS spin on main thread
    t = threading.Thread(target=ws_thread, daemon=True)
    t.start()
    rospy.spin()

if __name__ == "__main__":
    try:
        run(WS_URL)
    except KeyboardInterrupt:
        print("\nStopped.")
