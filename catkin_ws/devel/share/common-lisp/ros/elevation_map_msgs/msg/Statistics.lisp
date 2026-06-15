; Auto-generated. Do not edit!


(cl:in-package elevation_map_msgs-msg)


;//! \htmlinclude Statistics.msg.html

(cl:defclass <Statistics> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (pointcloud_process_fps
    :reader pointcloud_process_fps
    :initarg :pointcloud_process_fps
    :type cl:float
    :initform 0.0))
)

(cl:defclass Statistics (<Statistics>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Statistics>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Statistics)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elevation_map_msgs-msg:<Statistics> is deprecated: use elevation_map_msgs-msg:Statistics instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Statistics>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-msg:header-val is deprecated.  Use elevation_map_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'pointcloud_process_fps-val :lambda-list '(m))
(cl:defmethod pointcloud_process_fps-val ((m <Statistics>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-msg:pointcloud_process_fps-val is deprecated.  Use elevation_map_msgs-msg:pointcloud_process_fps instead.")
  (pointcloud_process_fps m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Statistics>) ostream)
  "Serializes a message object of type '<Statistics>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'pointcloud_process_fps))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Statistics>) istream)
  "Deserializes a message object of type '<Statistics>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'pointcloud_process_fps) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Statistics>)))
  "Returns string type for a message object of type '<Statistics>"
  "elevation_map_msgs/Statistics")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Statistics)))
  "Returns string type for a message object of type 'Statistics"
  "elevation_map_msgs/Statistics")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Statistics>)))
  "Returns md5sum for a message object of type '<Statistics>"
  "862e05f7b2e4eec3255cdbf6fad6ee44")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Statistics)))
  "Returns md5sum for a message object of type 'Statistics"
  "862e05f7b2e4eec3255cdbf6fad6ee44")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Statistics>)))
  "Returns full string definition for message of type '<Statistics>"
  (cl:format cl:nil " Header header~% float64 pointcloud_process_fps~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Statistics)))
  "Returns full string definition for message of type 'Statistics"
  (cl:format cl:nil " Header header~% float64 pointcloud_process_fps~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Statistics>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Statistics>))
  "Converts a ROS message object to a list"
  (cl:list 'Statistics
    (cl:cons ':header (header msg))
    (cl:cons ':pointcloud_process_fps (pointcloud_process_fps msg))
))
