;; Auto-generated. Do not edit!


(when (boundp 'elevation_map_msgs::ChannelInfo)
  (if (not (find-package "ELEVATION_MAP_MSGS"))
    (make-package "ELEVATION_MAP_MSGS"))
  (shadow 'ChannelInfo (find-package "ELEVATION_MAP_MSGS")))
(unless (find-package "ELEVATION_MAP_MSGS::CHANNELINFO")
  (make-package "ELEVATION_MAP_MSGS::CHANNELINFO"))

(in-package "ROS")
;;//! \htmlinclude ChannelInfo.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass elevation_map_msgs::ChannelInfo
  :super ros::object
  :slots (_header _channels ))

(defmethod elevation_map_msgs::ChannelInfo
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:channels __channels) (let (r) (dotimes (i 0) (push "" r)) r))
    )
   (send-super :init)
   (setq _header __header)
   (setq _channels __channels)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:channels
   (&optional __channels)
   (if __channels (setq _channels __channels)) _channels)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; string[] _channels
    (apply #'+ (mapcar #'(lambda (x) (+ 4 (length x))) _channels)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; string[] _channels
     (write-long (length _channels) s)
     (dolist (elem _channels)
       (write-long (length elem) s) (princ elem s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; string[] _channels
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _channels (make-list n))
     (dotimes (i n)
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setf (elt _channels i) (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
     ))
   ;;
   self)
  )

(setf (get elevation_map_msgs::ChannelInfo :md5sum-) "3486d52fe9f3586d814c3408f751762e")
(setf (get elevation_map_msgs::ChannelInfo :datatype-) "elevation_map_msgs/ChannelInfo")
(setf (get elevation_map_msgs::ChannelInfo :definition-)
      "Header header
string[] channels       # channel names for each layer
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



(provide :elevation_map_msgs/ChannelInfo "3486d52fe9f3586d814c3408f751762e")


