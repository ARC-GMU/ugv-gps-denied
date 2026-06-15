; Auto-generated. Do not edit!


(cl:in-package convex_plane_decomposition_msgs-msg)


;//! \htmlinclude PlanarRegion.msg.html

(cl:defclass <PlanarRegion> (roslisp-msg-protocol:ros-message)
  ((plane_parameters
    :reader plane_parameters
    :initarg :plane_parameters
    :type geometry_msgs-msg:Pose
    :initform (cl:make-instance 'geometry_msgs-msg:Pose))
   (bbox2d
    :reader bbox2d
    :initarg :bbox2d
    :type convex_plane_decomposition_msgs-msg:BoundingBox2d
    :initform (cl:make-instance 'convex_plane_decomposition_msgs-msg:BoundingBox2d))
   (boundary
    :reader boundary
    :initarg :boundary
    :type convex_plane_decomposition_msgs-msg:PolygonWithHoles2d
    :initform (cl:make-instance 'convex_plane_decomposition_msgs-msg:PolygonWithHoles2d))
   (insets
    :reader insets
    :initarg :insets
    :type (cl:vector convex_plane_decomposition_msgs-msg:PolygonWithHoles2d)
   :initform (cl:make-array 0 :element-type 'convex_plane_decomposition_msgs-msg:PolygonWithHoles2d :initial-element (cl:make-instance 'convex_plane_decomposition_msgs-msg:PolygonWithHoles2d))))
)

(cl:defclass PlanarRegion (<PlanarRegion>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PlanarRegion>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PlanarRegion)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name convex_plane_decomposition_msgs-msg:<PlanarRegion> is deprecated: use convex_plane_decomposition_msgs-msg:PlanarRegion instead.")))

(cl:ensure-generic-function 'plane_parameters-val :lambda-list '(m))
(cl:defmethod plane_parameters-val ((m <PlanarRegion>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:plane_parameters-val is deprecated.  Use convex_plane_decomposition_msgs-msg:plane_parameters instead.")
  (plane_parameters m))

(cl:ensure-generic-function 'bbox2d-val :lambda-list '(m))
(cl:defmethod bbox2d-val ((m <PlanarRegion>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:bbox2d-val is deprecated.  Use convex_plane_decomposition_msgs-msg:bbox2d instead.")
  (bbox2d m))

(cl:ensure-generic-function 'boundary-val :lambda-list '(m))
(cl:defmethod boundary-val ((m <PlanarRegion>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:boundary-val is deprecated.  Use convex_plane_decomposition_msgs-msg:boundary instead.")
  (boundary m))

(cl:ensure-generic-function 'insets-val :lambda-list '(m))
(cl:defmethod insets-val ((m <PlanarRegion>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:insets-val is deprecated.  Use convex_plane_decomposition_msgs-msg:insets instead.")
  (insets m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PlanarRegion>) ostream)
  "Serializes a message object of type '<PlanarRegion>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'plane_parameters) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'bbox2d) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'boundary) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'insets))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'insets))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PlanarRegion>) istream)
  "Deserializes a message object of type '<PlanarRegion>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'plane_parameters) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'bbox2d) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'boundary) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'insets) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'insets)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'convex_plane_decomposition_msgs-msg:PolygonWithHoles2d))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PlanarRegion>)))
  "Returns string type for a message object of type '<PlanarRegion>"
  "convex_plane_decomposition_msgs/PlanarRegion")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PlanarRegion)))
  "Returns string type for a message object of type 'PlanarRegion"
  "convex_plane_decomposition_msgs/PlanarRegion")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PlanarRegion>)))
  "Returns md5sum for a message object of type '<PlanarRegion>"
  "8cff8c52c8273f12e2fd17b9d4a3d417")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PlanarRegion)))
  "Returns md5sum for a message object of type 'PlanarRegion"
  "8cff8c52c8273f12e2fd17b9d4a3d417")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PlanarRegion>)))
  "Returns full string definition for message of type '<PlanarRegion>"
  (cl:format cl:nil "geometry_msgs/Pose plane_parameters~%~%BoundingBox2d bbox2d~%~%PolygonWithHoles2d boundary~%~%PolygonWithHoles2d[] insets~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: convex_plane_decomposition_msgs/BoundingBox2d~%# 3D, axis-aligned, bounding box~%float32 min_x~%float32 min_y~%float32 max_x~%float32 max_y~%================================================================================~%MSG: convex_plane_decomposition_msgs/PolygonWithHoles2d~%# Specification of a 2D polygon with holes~%Polygon2d outer_boundary~%Polygon2d[] holes~%================================================================================~%MSG: convex_plane_decomposition_msgs/Polygon2d~%# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PlanarRegion)))
  "Returns full string definition for message of type 'PlanarRegion"
  (cl:format cl:nil "geometry_msgs/Pose plane_parameters~%~%BoundingBox2d bbox2d~%~%PolygonWithHoles2d boundary~%~%PolygonWithHoles2d[] insets~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: convex_plane_decomposition_msgs/BoundingBox2d~%# 3D, axis-aligned, bounding box~%float32 min_x~%float32 min_y~%float32 max_x~%float32 max_y~%================================================================================~%MSG: convex_plane_decomposition_msgs/PolygonWithHoles2d~%# Specification of a 2D polygon with holes~%Polygon2d outer_boundary~%Polygon2d[] holes~%================================================================================~%MSG: convex_plane_decomposition_msgs/Polygon2d~%# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PlanarRegion>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'plane_parameters))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'bbox2d))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'boundary))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'insets) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PlanarRegion>))
  "Converts a ROS message object to a list"
  (cl:list 'PlanarRegion
    (cl:cons ':plane_parameters (plane_parameters msg))
    (cl:cons ':bbox2d (bbox2d msg))
    (cl:cons ':boundary (boundary msg))
    (cl:cons ':insets (insets msg))
))
