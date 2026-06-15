;; Auto-generated. Do not edit!


(when (boundp 'elevation_map_msgs::Statistics)
  (if (not (find-package "ELEVATION_MAP_MSGS"))
    (make-package "ELEVATION_MAP_MSGS"))
  (shadow 'Statistics (find-package "ELEVATION_MAP_MSGS")))
(unless (find-package "ELEVATION_MAP_MSGS::STATISTICS")
  (make-package "ELEVATION_MAP_MSGS::STATISTICS"))

(in-package "ROS")
;;//! \htmlinclude Statistics.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass elevation_map_msgs::Statistics
  :super ros::object
  :slots (_header _pointcloud_process_fps ))

(defmethod elevation_map_msgs::Statistics
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:pointcloud_process_fps __pointcloud_process_fps) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _pointcloud_process_fps (float __pointcloud_process_fps))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:pointcloud_process_fps
   (&optional __pointcloud_process_fps)
   (if __pointcloud_process_fps (setq _pointcloud_process_fps __pointcloud_process_fps)) _pointcloud_process_fps)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; float64 _pointcloud_process_fps
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; float64 _pointcloud_process_fps
       (sys::poke _pointcloud_process_fps (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; float64 _pointcloud_process_fps
     (setq _pointcloud_process_fps (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(setf (get elevation_map_msgs::Statistics :md5sum-) "862e05f7b2e4eec3255cdbf6fad6ee44")
(setf (get elevation_map_msgs::Statistics :datatype-) "elevation_map_msgs/Statistics")
(setf (get elevation_map_msgs::Statistics :definition-)
      " Header header
 float64 pointcloud_process_fps

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

")



(provide :elevation_map_msgs/Statistics "862e05f7b2e4eec3255cdbf6fad6ee44")


