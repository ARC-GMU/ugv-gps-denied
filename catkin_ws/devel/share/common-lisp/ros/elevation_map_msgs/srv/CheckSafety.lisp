; Auto-generated. Do not edit!


(cl:in-package elevation_map_msgs-srv)


;//! \htmlinclude CheckSafety-request.msg.html

(cl:defclass <CheckSafety-request> (roslisp-msg-protocol:ros-message)
  ((polygons
    :reader polygons
    :initarg :polygons
    :type (cl:vector geometry_msgs-msg:PolygonStamped)
   :initform (cl:make-array 0 :element-type 'geometry_msgs-msg:PolygonStamped :initial-element (cl:make-instance 'geometry_msgs-msg:PolygonStamped)))
   (compute_untraversable_polygon
    :reader compute_untraversable_polygon
    :initarg :compute_untraversable_polygon
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass CheckSafety-request (<CheckSafety-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CheckSafety-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CheckSafety-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elevation_map_msgs-srv:<CheckSafety-request> is deprecated: use elevation_map_msgs-srv:CheckSafety-request instead.")))

(cl:ensure-generic-function 'polygons-val :lambda-list '(m))
(cl:defmethod polygons-val ((m <CheckSafety-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:polygons-val is deprecated.  Use elevation_map_msgs-srv:polygons instead.")
  (polygons m))

(cl:ensure-generic-function 'compute_untraversable_polygon-val :lambda-list '(m))
(cl:defmethod compute_untraversable_polygon-val ((m <CheckSafety-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:compute_untraversable_polygon-val is deprecated.  Use elevation_map_msgs-srv:compute_untraversable_polygon instead.")
  (compute_untraversable_polygon m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CheckSafety-request>) ostream)
  "Serializes a message object of type '<CheckSafety-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'polygons))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'polygons))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'compute_untraversable_polygon) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CheckSafety-request>) istream)
  "Deserializes a message object of type '<CheckSafety-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'polygons) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'polygons)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'geometry_msgs-msg:PolygonStamped))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
    (cl:setf (cl:slot-value msg 'compute_untraversable_polygon) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CheckSafety-request>)))
  "Returns string type for a service object of type '<CheckSafety-request>"
  "elevation_map_msgs/CheckSafetyRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CheckSafety-request)))
  "Returns string type for a service object of type 'CheckSafety-request"
  "elevation_map_msgs/CheckSafetyRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CheckSafety-request>)))
  "Returns md5sum for a message object of type '<CheckSafety-request>"
  "137df6a3ff37546adfad4f1d40e233b4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CheckSafety-request)))
  "Returns md5sum for a message object of type 'CheckSafety-request"
  "137df6a3ff37546adfad4f1d40e233b4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CheckSafety-request>)))
  "Returns full string definition for message of type '<CheckSafety-request>"
  (cl:format cl:nil "# Polygons to check~%geometry_msgs/PolygonStamped[] polygons~%bool compute_untraversable_polygon~%~%# Results~%~%================================================================================~%MSG: geometry_msgs/PolygonStamped~%# This represents a Polygon with reference coordinate frame and timestamp~%Header header~%Polygon polygon~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Polygon~%#A specification of a polygon where the first and last points are assumed to be connected~%Point32[] points~%~%================================================================================~%MSG: geometry_msgs/Point32~%# This contains the position of a point in free space(with 32 bits of precision).~%# It is recommeded to use Point wherever possible instead of Point32.  ~%# ~%# This recommendation is to promote interoperability.  ~%#~%# This message is designed to take up less space when sending~%# lots of points at once, as in the case of a PointCloud.  ~%~%float32 x~%float32 y~%float32 z~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CheckSafety-request)))
  "Returns full string definition for message of type 'CheckSafety-request"
  (cl:format cl:nil "# Polygons to check~%geometry_msgs/PolygonStamped[] polygons~%bool compute_untraversable_polygon~%~%# Results~%~%================================================================================~%MSG: geometry_msgs/PolygonStamped~%# This represents a Polygon with reference coordinate frame and timestamp~%Header header~%Polygon polygon~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Polygon~%#A specification of a polygon where the first and last points are assumed to be connected~%Point32[] points~%~%================================================================================~%MSG: geometry_msgs/Point32~%# This contains the position of a point in free space(with 32 bits of precision).~%# It is recommeded to use Point wherever possible instead of Point32.  ~%# ~%# This recommendation is to promote interoperability.  ~%#~%# This message is designed to take up less space when sending~%# lots of points at once, as in the case of a PointCloud.  ~%~%float32 x~%float32 y~%float32 z~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CheckSafety-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'polygons) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CheckSafety-request>))
  "Converts a ROS message object to a list"
  (cl:list 'CheckSafety-request
    (cl:cons ':polygons (polygons msg))
    (cl:cons ':compute_untraversable_polygon (compute_untraversable_polygon msg))
))
;//! \htmlinclude CheckSafety-response.msg.html

(cl:defclass <CheckSafety-response> (roslisp-msg-protocol:ros-message)
  ((is_safe
    :reader is_safe
    :initarg :is_safe
    :type (cl:vector cl:boolean)
   :initform (cl:make-array 0 :element-type 'cl:boolean :initial-element cl:nil))
   (traversability
    :reader traversability
    :initarg :traversability
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (untraversable_polygons
    :reader untraversable_polygons
    :initarg :untraversable_polygons
    :type (cl:vector geometry_msgs-msg:PolygonStamped)
   :initform (cl:make-array 0 :element-type 'geometry_msgs-msg:PolygonStamped :initial-element (cl:make-instance 'geometry_msgs-msg:PolygonStamped))))
)

(cl:defclass CheckSafety-response (<CheckSafety-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CheckSafety-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CheckSafety-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name elevation_map_msgs-srv:<CheckSafety-response> is deprecated: use elevation_map_msgs-srv:CheckSafety-response instead.")))

(cl:ensure-generic-function 'is_safe-val :lambda-list '(m))
(cl:defmethod is_safe-val ((m <CheckSafety-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:is_safe-val is deprecated.  Use elevation_map_msgs-srv:is_safe instead.")
  (is_safe m))

(cl:ensure-generic-function 'traversability-val :lambda-list '(m))
(cl:defmethod traversability-val ((m <CheckSafety-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:traversability-val is deprecated.  Use elevation_map_msgs-srv:traversability instead.")
  (traversability m))

(cl:ensure-generic-function 'untraversable_polygons-val :lambda-list '(m))
(cl:defmethod untraversable_polygons-val ((m <CheckSafety-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader elevation_map_msgs-srv:untraversable_polygons-val is deprecated.  Use elevation_map_msgs-srv:untraversable_polygons instead.")
  (untraversable_polygons m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CheckSafety-response>) ostream)
  "Serializes a message object of type '<CheckSafety-response>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'is_safe))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if ele 1 0)) ostream))
   (cl:slot-value msg 'is_safe))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'traversability))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'traversability))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'untraversable_polygons))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'untraversable_polygons))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CheckSafety-response>) istream)
  "Deserializes a message object of type '<CheckSafety-response>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'is_safe) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'is_safe)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:not (cl:zerop (cl:read-byte istream)))))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'traversability) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'traversability)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits))))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'untraversable_polygons) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'untraversable_polygons)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'geometry_msgs-msg:PolygonStamped))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CheckSafety-response>)))
  "Returns string type for a service object of type '<CheckSafety-response>"
  "elevation_map_msgs/CheckSafetyResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CheckSafety-response)))
  "Returns string type for a service object of type 'CheckSafety-response"
  "elevation_map_msgs/CheckSafetyResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CheckSafety-response>)))
  "Returns md5sum for a message object of type '<CheckSafety-response>"
  "137df6a3ff37546adfad4f1d40e233b4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CheckSafety-response)))
  "Returns md5sum for a message object of type 'CheckSafety-response"
  "137df6a3ff37546adfad4f1d40e233b4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CheckSafety-response>)))
  "Returns full string definition for message of type '<CheckSafety-response>"
  (cl:format cl:nil "bool[] is_safe~%~%# Estimate of the traversability of the path.~%# Ranges from 0 to 1 where 0 means not traversable and 1 highly traversable.~%float64[] traversability~%~%# Polygons that are untraversable.~%geometry_msgs/PolygonStamped[] untraversable_polygons~%~%~%================================================================================~%MSG: geometry_msgs/PolygonStamped~%# This represents a Polygon with reference coordinate frame and timestamp~%Header header~%Polygon polygon~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Polygon~%#A specification of a polygon where the first and last points are assumed to be connected~%Point32[] points~%~%================================================================================~%MSG: geometry_msgs/Point32~%# This contains the position of a point in free space(with 32 bits of precision).~%# It is recommeded to use Point wherever possible instead of Point32.  ~%# ~%# This recommendation is to promote interoperability.  ~%#~%# This message is designed to take up less space when sending~%# lots of points at once, as in the case of a PointCloud.  ~%~%float32 x~%float32 y~%float32 z~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CheckSafety-response)))
  "Returns full string definition for message of type 'CheckSafety-response"
  (cl:format cl:nil "bool[] is_safe~%~%# Estimate of the traversability of the path.~%# Ranges from 0 to 1 where 0 means not traversable and 1 highly traversable.~%float64[] traversability~%~%# Polygons that are untraversable.~%geometry_msgs/PolygonStamped[] untraversable_polygons~%~%~%================================================================================~%MSG: geometry_msgs/PolygonStamped~%# This represents a Polygon with reference coordinate frame and timestamp~%Header header~%Polygon polygon~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Polygon~%#A specification of a polygon where the first and last points are assumed to be connected~%Point32[] points~%~%================================================================================~%MSG: geometry_msgs/Point32~%# This contains the position of a point in free space(with 32 bits of precision).~%# It is recommeded to use Point wherever possible instead of Point32.  ~%# ~%# This recommendation is to promote interoperability.  ~%#~%# This message is designed to take up less space when sending~%# lots of points at once, as in the case of a PointCloud.  ~%~%float32 x~%float32 y~%float32 z~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CheckSafety-response>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'is_safe) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 1)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'traversability) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'untraversable_polygons) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CheckSafety-response>))
  "Converts a ROS message object to a list"
  (cl:list 'CheckSafety-response
    (cl:cons ':is_safe (is_safe msg))
    (cl:cons ':traversability (traversability msg))
    (cl:cons ':untraversable_polygons (untraversable_polygons msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'CheckSafety)))
  'CheckSafety-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'CheckSafety)))
  'CheckSafety-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CheckSafety)))
  "Returns string type for a service object of type '<CheckSafety>"
  "elevation_map_msgs/CheckSafety")