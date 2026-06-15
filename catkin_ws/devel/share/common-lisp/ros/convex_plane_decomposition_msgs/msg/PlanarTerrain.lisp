; Auto-generated. Do not edit!


(cl:in-package convex_plane_decomposition_msgs-msg)


;//! \htmlinclude PlanarTerrain.msg.html

(cl:defclass <PlanarTerrain> (roslisp-msg-protocol:ros-message)
  ((planarRegions
    :reader planarRegions
    :initarg :planarRegions
    :type (cl:vector convex_plane_decomposition_msgs-msg:PlanarRegion)
   :initform (cl:make-array 0 :element-type 'convex_plane_decomposition_msgs-msg:PlanarRegion :initial-element (cl:make-instance 'convex_plane_decomposition_msgs-msg:PlanarRegion)))
   (gridmap
    :reader gridmap
    :initarg :gridmap
    :type grid_map_msgs-msg:GridMap
    :initform (cl:make-instance 'grid_map_msgs-msg:GridMap)))
)

(cl:defclass PlanarTerrain (<PlanarTerrain>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PlanarTerrain>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PlanarTerrain)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name convex_plane_decomposition_msgs-msg:<PlanarTerrain> is deprecated: use convex_plane_decomposition_msgs-msg:PlanarTerrain instead.")))

(cl:ensure-generic-function 'planarRegions-val :lambda-list '(m))
(cl:defmethod planarRegions-val ((m <PlanarTerrain>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:planarRegions-val is deprecated.  Use convex_plane_decomposition_msgs-msg:planarRegions instead.")
  (planarRegions m))

(cl:ensure-generic-function 'gridmap-val :lambda-list '(m))
(cl:defmethod gridmap-val ((m <PlanarTerrain>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader convex_plane_decomposition_msgs-msg:gridmap-val is deprecated.  Use convex_plane_decomposition_msgs-msg:gridmap instead.")
  (gridmap m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PlanarTerrain>) ostream)
  "Serializes a message object of type '<PlanarTerrain>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'planarRegions))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'planarRegions))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'gridmap) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PlanarTerrain>) istream)
  "Deserializes a message object of type '<PlanarTerrain>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'planarRegions) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'planarRegions)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'convex_plane_decomposition_msgs-msg:PlanarRegion))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'gridmap) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PlanarTerrain>)))
  "Returns string type for a message object of type '<PlanarTerrain>"
  "convex_plane_decomposition_msgs/PlanarTerrain")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PlanarTerrain)))
  "Returns string type for a message object of type 'PlanarTerrain"
  "convex_plane_decomposition_msgs/PlanarTerrain")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PlanarTerrain>)))
  "Returns md5sum for a message object of type '<PlanarTerrain>"
  "081e702fce247ef5685dd96b39e3dfd4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PlanarTerrain)))
  "Returns md5sum for a message object of type 'PlanarTerrain"
  "081e702fce247ef5685dd96b39e3dfd4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PlanarTerrain>)))
  "Returns full string definition for message of type '<PlanarTerrain>"
  (cl:format cl:nil "PlanarRegion[] planarRegions~%grid_map_msgs/GridMap gridmap~%================================================================================~%MSG: convex_plane_decomposition_msgs/PlanarRegion~%geometry_msgs/Pose plane_parameters~%~%BoundingBox2d bbox2d~%~%PolygonWithHoles2d boundary~%~%PolygonWithHoles2d[] insets~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: convex_plane_decomposition_msgs/BoundingBox2d~%# 3D, axis-aligned, bounding box~%float32 min_x~%float32 min_y~%float32 max_x~%float32 max_y~%================================================================================~%MSG: convex_plane_decomposition_msgs/PolygonWithHoles2d~%# Specification of a 2D polygon with holes~%Polygon2d outer_boundary~%Polygon2d[] holes~%================================================================================~%MSG: convex_plane_decomposition_msgs/Polygon2d~%# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%================================================================================~%MSG: grid_map_msgs/GridMap~%# Grid map header~%GridMapInfo info~%~%# Grid map layer names.~%string[] layers~%~%# Grid map basic layer names (optional). The basic layers~%# determine which layers from `layers` need to be valid~%# in order for a cell of the grid map to be valid.~%string[] basic_layers~%~%# Grid map data.~%std_msgs/Float32MultiArray[] data~%~%# Row start index (default 0).~%uint16 outer_start_index~%~%# Column start index (default 0).~%uint16 inner_start_index~%~%================================================================================~%MSG: grid_map_msgs/GridMapInfo~%# Header (time and frame)~%Header header~%~%# Resolution of the grid [m/cell].~%float64 resolution~%~%# Length in x-direction [m].~%float64 length_x~%~%# Length in y-direction [m].~%float64 length_y~%~%# Pose of the grid map center in the frame defined in `header` [m].~%geometry_msgs/Pose pose~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: std_msgs/Float32MultiArray~%# Please look at the MultiArrayLayout message definition for~%# documentation on all multiarrays.~%~%MultiArrayLayout  layout        # specification of data layout~%float32[]         data          # array of data~%~%~%================================================================================~%MSG: std_msgs/MultiArrayLayout~%# The multiarray declares a generic multi-dimensional array of a~%# particular data type.  Dimensions are ordered from outer most~%# to inner most.~%~%MultiArrayDimension[] dim # Array of dimension properties~%uint32 data_offset        # padding elements at front of data~%~%# Accessors should ALWAYS be written in terms of dimension stride~%# and specified outer-most dimension first.~%# ~%# multiarray(i,j,k) = data[data_offset + dim_stride[1]*i + dim_stride[2]*j + k]~%#~%# A standard, 3-channel 640x480 image with interleaved color channels~%# would be specified as:~%#~%# dim[0].label  = \"height\"~%# dim[0].size   = 480~%# dim[0].stride = 3*640*480 = 921600  (note dim[0] stride is just size of image)~%# dim[1].label  = \"width\"~%# dim[1].size   = 640~%# dim[1].stride = 3*640 = 1920~%# dim[2].label  = \"channel\"~%# dim[2].size   = 3~%# dim[2].stride = 3~%#~%# multiarray(i,j,k) refers to the ith row, jth column, and kth channel.~%~%================================================================================~%MSG: std_msgs/MultiArrayDimension~%string label   # label of given dimension~%uint32 size    # size of given dimension (in type units)~%uint32 stride  # stride of given dimension~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PlanarTerrain)))
  "Returns full string definition for message of type 'PlanarTerrain"
  (cl:format cl:nil "PlanarRegion[] planarRegions~%grid_map_msgs/GridMap gridmap~%================================================================================~%MSG: convex_plane_decomposition_msgs/PlanarRegion~%geometry_msgs/Pose plane_parameters~%~%BoundingBox2d bbox2d~%~%PolygonWithHoles2d boundary~%~%PolygonWithHoles2d[] insets~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: convex_plane_decomposition_msgs/BoundingBox2d~%# 3D, axis-aligned, bounding box~%float32 min_x~%float32 min_y~%float32 max_x~%float32 max_y~%================================================================================~%MSG: convex_plane_decomposition_msgs/PolygonWithHoles2d~%# Specification of a 2D polygon with holes~%Polygon2d outer_boundary~%Polygon2d[] holes~%================================================================================~%MSG: convex_plane_decomposition_msgs/Polygon2d~%# Specification of a 2D polygon where the first and last points are connected~%Point2d[] points~%================================================================================~%MSG: convex_plane_decomposition_msgs/Point2d~%float32 x~%float32 y~%================================================================================~%MSG: grid_map_msgs/GridMap~%# Grid map header~%GridMapInfo info~%~%# Grid map layer names.~%string[] layers~%~%# Grid map basic layer names (optional). The basic layers~%# determine which layers from `layers` need to be valid~%# in order for a cell of the grid map to be valid.~%string[] basic_layers~%~%# Grid map data.~%std_msgs/Float32MultiArray[] data~%~%# Row start index (default 0).~%uint16 outer_start_index~%~%# Column start index (default 0).~%uint16 inner_start_index~%~%================================================================================~%MSG: grid_map_msgs/GridMapInfo~%# Header (time and frame)~%Header header~%~%# Resolution of the grid [m/cell].~%float64 resolution~%~%# Length in x-direction [m].~%float64 length_x~%~%# Length in y-direction [m].~%float64 length_y~%~%# Pose of the grid map center in the frame defined in `header` [m].~%geometry_msgs/Pose pose~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: std_msgs/Float32MultiArray~%# Please look at the MultiArrayLayout message definition for~%# documentation on all multiarrays.~%~%MultiArrayLayout  layout        # specification of data layout~%float32[]         data          # array of data~%~%~%================================================================================~%MSG: std_msgs/MultiArrayLayout~%# The multiarray declares a generic multi-dimensional array of a~%# particular data type.  Dimensions are ordered from outer most~%# to inner most.~%~%MultiArrayDimension[] dim # Array of dimension properties~%uint32 data_offset        # padding elements at front of data~%~%# Accessors should ALWAYS be written in terms of dimension stride~%# and specified outer-most dimension first.~%# ~%# multiarray(i,j,k) = data[data_offset + dim_stride[1]*i + dim_stride[2]*j + k]~%#~%# A standard, 3-channel 640x480 image with interleaved color channels~%# would be specified as:~%#~%# dim[0].label  = \"height\"~%# dim[0].size   = 480~%# dim[0].stride = 3*640*480 = 921600  (note dim[0] stride is just size of image)~%# dim[1].label  = \"width\"~%# dim[1].size   = 640~%# dim[1].stride = 3*640 = 1920~%# dim[2].label  = \"channel\"~%# dim[2].size   = 3~%# dim[2].stride = 3~%#~%# multiarray(i,j,k) refers to the ith row, jth column, and kth channel.~%~%================================================================================~%MSG: std_msgs/MultiArrayDimension~%string label   # label of given dimension~%uint32 size    # size of given dimension (in type units)~%uint32 stride  # stride of given dimension~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PlanarTerrain>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'planarRegions) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'gridmap))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PlanarTerrain>))
  "Converts a ROS message object to a list"
  (cl:list 'PlanarTerrain
    (cl:cons ':planarRegions (planarRegions msg))
    (cl:cons ':gridmap (gridmap msg))
))
