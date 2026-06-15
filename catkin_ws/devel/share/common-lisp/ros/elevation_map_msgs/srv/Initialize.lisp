; Auto-generated. Do not edit!


(cl:in-package elevation_map_msgs-srv)


;//! \htmlinclude Initialize-request.msg.html

(cl:defclass <Initialize-request> (roslisp-msg-protocol:ros-message)
  ((type
    :reader type
    :initarg :type
    :type cl:fixnum
    :initform 0)
   (method
    :reader method
    :initarg :method
    :type cl:fixnum
    :initform 0)
   (points
    :reader points
    :initarg :points
    :type (cl:vector geometry_msgs-msg:PointStamped)
   :initform (cl:make-array 0 :element-type 'geometry_msgs-msg:PointStamped :initial-element (cl:make-instance 'geometry_msgs-msg:PointStamped))))
)

(cl:defclass Initialize-request (<Initialize-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Initialize-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Initialize-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elevation_map_msgs-srv:<Initialize-request> is deprecated: use elevation_map_msgs-srv:Initialize-request instead.")))

(cl:ensure-generic-function 'type-val :lambda-list '(m))
(cl:defmethod type-val ((m <Initialize-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:type-val is deprecated.  Use elevation_map_msgs-srv:type instead.")
  (type m))

(cl:ensure-generic-function 'method-val :lambda-list '(m))
(cl:defmethod method-val ((m <Initialize-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:method-val is deprecated.  Use elevation_map_msgs-srv:method instead.")
  (method m))

(cl:ensure-generic-function 'points-val :lambda-list '(m))
(cl:defmethod points-val ((m <Initialize-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:points-val is deprecated.  Use elevation_map_msgs-srv:points instead.")
  (points m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<Initialize-request>)))
    "Constants for message type '<Initialize-request>"
  '((:POINTS . 0)
    (:NEAREST . 0)
    (:LINEAR . 1)
    (:CUBIC . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'Initialize-request)))
    "Constants for message type 'Initialize-request"
  '((:POINTS . 0)
    (:NEAREST . 0)
    (:LINEAR . 1)
    (:CUBIC . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Initialize-request>) ostream)
  "Serializes a message object of type '<Initialize-request>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'type)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'method)) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'points))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'points))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Initialize-request>) istream)
  "Deserializes a message object of type '<Initialize-request>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'type)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'method)) (cl:read-byte istream))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'points) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'points)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'geometry_msgs-msg:PointStamped))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Initialize-request>)))
  "Returns string type for a service object of type '<Initialize-request>"
  "elevation_map_msgs/InitializeRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Initialize-request)))
  "Returns string type for a service object of type 'Initialize-request"
  "elevation_map_msgs/InitializeRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Initialize-request>)))
  "Returns md5sum for a message object of type '<Initialize-request>"
  "2132848049aeee984c2fb7de662fe983")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Initialize-request)))
  "Returns md5sum for a message object of type 'Initialize-request"
  "2132848049aeee984c2fb7de662fe983")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Initialize-request>)))
  "Returns full string definition for message of type '<Initialize-request>"
  (cl:format cl:nil "# Initialization methods~%# TODO add more methods.~%uint8 POINTS=0~%~%uint8 NEAREST=0~%uint8 LINEAR=1~%uint8 CUBIC=2~%~%uint8 type~%uint8 method~%geometry_msgs/PointStamped[] points~%~%~%================================================================================~%MSG: geometry_msgs/PointStamped~%# This represents a Point with reference coordinate frame and timestamp~%Header header~%Point point~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Initialize-request)))
  "Returns full string definition for message of type 'Initialize-request"
  (cl:format cl:nil "# Initialization methods~%# TODO add more methods.~%uint8 POINTS=0~%~%uint8 NEAREST=0~%uint8 LINEAR=1~%uint8 CUBIC=2~%~%uint8 type~%uint8 method~%geometry_msgs/PointStamped[] points~%~%~%================================================================================~%MSG: geometry_msgs/PointStamped~%# This represents a Point with reference coordinate frame and timestamp~%Header header~%Point point~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Initialize-request>))
  (cl:+ 0
     1
     1
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'points) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Initialize-request>))
  "Converts a ROS message object to a list"
  (cl:list 'Initialize-request
    (cl:cons ':type (type msg))
    (cl:cons ':method (method msg))
    (cl:cons ':points (points msg))
))
;//! \htmlinclude Initialize-response.msg.html

(cl:defclass <Initialize-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass Initialize-response (<Initialize-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Initialize-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Initialize-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elevation_map_msgs-srv:<Initialize-response> is deprecated: use elevation_map_msgs-srv:Initialize-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <Initialize-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:success-val is deprecated.  Use elevation_map_msgs-srv:success instead.")
  (success m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Initialize-response>) ostream)
  "Serializes a message object of type '<Initialize-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Initialize-response>) istream)
  "Deserializes a message object of type '<Initialize-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Initialize-response>)))
  "Returns string type for a service object of type '<Initialize-response>"
  "elevation_map_msgs/InitializeResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Initialize-response)))
  "Returns string type for a service object of type 'Initialize-response"
  "elevation_map_msgs/InitializeResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Initialize-response>)))
  "Returns md5sum for a message object of type '<Initialize-response>"
  "2132848049aeee984c2fb7de662fe983")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Initialize-response)))
  "Returns md5sum for a message object of type 'Initialize-response"
  "2132848049aeee984c2fb7de662fe983")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Initialize-response>)))
  "Returns full string definition for message of type '<Initialize-response>"
  (cl:format cl:nil "bool success~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Initialize-response)))
  "Returns full string definition for message of type 'Initialize-response"
  (cl:format cl:nil "bool success~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Initialize-response>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Initialize-response>))
  "Converts a ROS message object to a list"
  (cl:list 'Initialize-response
    (cl:cons ':success (success msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'Initialize)))
  'Initialize-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'Initialize)))
  'Initialize-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Initialize)))
  "Returns string type for a service object of type '<Initialize>"
  "elevation_map_msgs/Initialize")