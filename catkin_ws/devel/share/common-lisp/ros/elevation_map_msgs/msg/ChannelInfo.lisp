; Auto-generated. Do not edit!


(cl:in-package elevation_map_msgs-msg)


;//! \htmlinclude ChannelInfo.msg.html

(cl:defclass <ChannelInfo> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (channels
    :reader channels
    :initarg :channels
    :type (cl:vector cl:string)
   :initform (cl:make-array 0 :element-type 'cl:string :initial-element "")))
)

(cl:defclass ChannelInfo (<ChannelInfo>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ChannelInfo>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ChannelInfo)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elevation_map_msgs-msg:<ChannelInfo> is deprecated: use elevation_map_msgs-msg:ChannelInfo instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <ChannelInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-msg:header-val is deprecated.  Use elevation_map_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'channels-val :lambda-list '(m))
(cl:defmethod channels-val ((m <ChannelInfo>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-msg:channels-val is deprecated.  Use elevation_map_msgs-msg:channels instead.")
  (channels m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ChannelInfo>) ostream)
  "Serializes a message object of type '<ChannelInfo>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'channels))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((__ros_str_len (cl:length ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) ele))
   (cl:slot-value msg 'channels))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ChannelInfo>) istream)
  "Deserializes a message object of type '<ChannelInfo>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'channels) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'channels)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:aref vals i) __ros_str_idx) (cl:code-char (cl:read-byte istream))))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ChannelInfo>)))
  "Returns string type for a message object of type '<ChannelInfo>"
  "elevation_map_msgs/ChannelInfo")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ChannelInfo)))
  "Returns string type for a message object of type 'ChannelInfo"
  "elevation_map_msgs/ChannelInfo")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ChannelInfo>)))
  "Returns md5sum for a message object of type '<ChannelInfo>"
  "3486d52fe9f3586d814c3408f751762e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ChannelInfo)))
  "Returns md5sum for a message object of type 'ChannelInfo"
  "3486d52fe9f3586d814c3408f751762e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ChannelInfo>)))
  "Returns full string definition for message of type '<ChannelInfo>"
  (cl:format cl:nil "Header header~%string[] channels       # channel names for each layer~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ChannelInfo)))
  "Returns full string definition for message of type 'ChannelInfo"
  (cl:format cl:nil "Header header~%string[] channels       # channel names for each layer~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ChannelInfo>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'channels) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4 (cl:length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ChannelInfo>))
  "Converts a ROS message object to a list"
  (cl:list 'ChannelInfo
    (cl:cons ':header (header msg))
    (cl:cons ':channels (channels msg))
))
