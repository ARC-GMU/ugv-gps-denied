; Auto-generated. Do not edit!


(cl:in-package convex_plane_decomposition_msgs-msg)


;//! \htmlinclude Polygon2d.msg.html

(cl:defclass <Polygon2d> (roslisp-msg-protocol:ros-message)
  ((points
    :reader points
    :initarg :points
    :type (cl:vector convex_plane_decomposition_msgs-msg:Point2d)
   :initform (cl:make-array 0 :element-type 'convex_plane_decomposition_msgs-msg:Point2d :initial-element (cl:make-instance 'convex_plane_decomposition_msgs-msg:Point2d))))
)

(cl:defclass Polygon2d (<Polygon2d>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Polygon2d>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Polygon2d)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name convex_plane_decomposition_msgs-msg:<Polygon2d> is deprecated: use convex_plane_decomposition_msgs-msg:Polygon2d instead.")))

(cl:ensure-generic-function 'points-val :lambda-list '(m))
(cl:defmethod points-val ((m <Polygon2d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:points-val is deprecated.  Use convex_plane_decomposition_msgs-msg:points instead.")
  (points m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Polygon2d>) ostream)
  "Serializes a message object of type '<Polygon2d>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'points))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'points))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Polygon2d>) istream)
  "Deserializes a message object of type '<Polygon2d>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'points) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'points)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'convex_plane_decomposition_msgs-msg:Point2d))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Polygon2d>)))
  "Returns string type for a message object of type '<Polygon2d>"
  "convex_plane_decomposition_msgs/Polygon2d")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Polygon2d)))
  "Returns string type for a message object of type 'Polygon2d"
  "convex_plane_decomposition_msgs/Polygon2d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Polygon2d>)))
  "Returns md5sum for a message object of type '<Polygon2d>"
  "0083ddac30f807eeef29c66ffedb79c7")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Polygon2d)))
  "Returns md5sum for a message object of type 'Polygon2d"
  "0083ddac30f807eeef29c66ffedb79c7")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Polygon2d>)))
  "Returns full string definition for message of type '<Polygon2d>"
  (cl:format cl:nil "# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Polygon2d)))
  "Returns full string definition for message of type 'Polygon2d"
  (cl:format cl:nil "# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Polygon2d>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'points) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Polygon2d>))
  "Converts a ROS message object to a list"
  (cl:list 'Polygon2d
    (cl:cons ':points (points msg))
))
