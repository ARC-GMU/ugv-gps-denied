; Auto-generated. Do not edit!


(cl:in-package convex_plane_decomposition_msgs-msg)


;//! \htmlinclude PolygonWithHoles2d.msg.html

(cl:defclass <PolygonWithHoles2d> (roslisp-msg-protocol:ros-message)
  ((outer_boundary
    :reader outer_boundary
    :initarg :outer_boundary
    :type convex_plane_decomposition_msgs-msg:Polygon2d
    :initform (cl:make-instance 'convex_plane_decomposition_msgs-msg:Polygon2d))
   (holes
    :reader holes
    :initarg :holes
    :type (cl:vector convex_plane_decomposition_msgs-msg:Polygon2d)
   :initform (cl:make-array 0 :element-type 'convex_plane_decomposition_msgs-msg:Polygon2d :initial-element (cl:make-instance 'convex_plane_decomposition_msgs-msg:Polygon2d))))
)

(cl:defclass PolygonWithHoles2d (<PolygonWithHoles2d>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PolygonWithHoles2d>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PolygonWithHoles2d)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name convex_plane_decomposition_msgs-msg:<PolygonWithHoles2d> is deprecated: use convex_plane_decomposition_msgs-msg:PolygonWithHoles2d instead.")))

(cl:ensure-generic-function 'outer_boundary-val :lambda-list '(m))
(cl:defmethod outer_boundary-val ((m <PolygonWithHoles2d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:outer_boundary-val is deprecated.  Use convex_plane_decomposition_msgs-msg:outer_boundary instead.")
  (outer_boundary m))

(cl:ensure-generic-function 'holes-val :lambda-list '(m))
(cl:defmethod holes-val ((m <PolygonWithHoles2d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:holes-val is deprecated.  Use convex_plane_decomposition_msgs-msg:holes instead.")
  (holes m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PolygonWithHoles2d>) ostream)
  "Serializes a message object of type '<PolygonWithHoles2d>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'outer_boundary) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'holes))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'holes))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PolygonWithHoles2d>) istream)
  "Deserializes a message object of type '<PolygonWithHoles2d>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'outer_boundary) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'holes) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'holes)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'convex_plane_decomposition_msgs-msg:Polygon2d))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PolygonWithHoles2d>)))
  "Returns string type for a message object of type '<PolygonWithHoles2d>"
  "convex_plane_decomposition_msgs/PolygonWithHoles2d")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PolygonWithHoles2d)))
  "Returns string type for a message object of type 'PolygonWithHoles2d"
  "convex_plane_decomposition_msgs/PolygonWithHoles2d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PolygonWithHoles2d>)))
  "Returns md5sum for a message object of type '<PolygonWithHoles2d>"
  "62e09666eefc245f9ca3347875cb36cc")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PolygonWithHoles2d)))
  "Returns md5sum for a message object of type 'PolygonWithHoles2d"
  "62e09666eefc245f9ca3347875cb36cc")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PolygonWithHoles2d>)))
  "Returns full string definition for message of type '<PolygonWithHoles2d>"
  (cl:format cl:nil "# Specification of a 2D polygon with holes~%Polygon2d outer_boundary~%Polygon2d[] holes~%================================================================================~%MSG: convex_plane_decomposition_msgs/Polygon2d~%# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PolygonWithHoles2d)))
  "Returns full string definition for message of type 'PolygonWithHoles2d"
  (cl:format cl:nil "# Specification of a 2D polygon with holes~%Polygon2d outer_boundary~%Polygon2d[] holes~%================================================================================~%MSG: convex_plane_decomposition_msgs/Polygon2d~%# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PolygonWithHoles2d>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'outer_boundary))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'holes) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PolygonWithHoles2d>))
  "Converts a ROS message object to a list"
  (cl:list 'PolygonWithHoles2d
    (cl:cons ':outer_boundary (outer_boundary msg))
    (cl:cons ':holes (holes msg))
))
