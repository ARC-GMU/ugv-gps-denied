;; Auto-generated. Do not edit!


(when (boundp 'convex_plane_decomposition_msgs::PlanarTerrain)
  (if (not (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
    (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
  (shadow 'PlanarTerrain (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS")))
(unless (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS::PLANARTERRAIN")
  (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS::PLANARTERRAIN"))

(in-package "ROS")
;;//! \htmlinclude PlanarTerrain.msg.html
(if (not (find-package "GRID_MAP_MSGS"))
  (ros::roseus-add-msgs "grid_map_msgs"))


(defclass convex_plane_decomposition_msgs::PlanarTerrain
  :super ros::object
  :slots (_planarRegions _gridmap ))

(defmethod convex_plane_decomposition_msgs::PlanarTerrain
  (:init
   (&key
    ((:planarRegions __planarRegions) ())
    ((:gridmap __gridmap) (instance grid_map_msgs::GridMap :init))
    )
   (send-super :init)
   (setq _planarRegions __planarRegions)
   (setq _gridmap __gridmap)
   self)
  (:planarRegions
   (&rest __planarRegions)
   (if (keywordp (car __planarRegions))
       (send* _planarRegions __planarRegions)
     (progn
       (if __planarRegions (setq _planarRegions (car __planarRegions)))
       _planarRegions)))
  (:gridmap
   (&rest __gridmap)
   (if (keywordp (car __gridmap))
       (send* _gridmap __gridmap)
     (progn
       (if __gridmap (setq _gridmap (car __gridmap)))
       _gridmap)))
  (:serialization-length
   ()
   (+
    ;; convex_plane_decomposition_msgs/PlanarRegion[] _planarRegions
    (apply #'+ (send-all _planarRegions :serialization-length)) 4
    ;; grid_map_msgs/GridMap _gridmap
    (send _gridmap :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; convex_plane_decomposition_msgs/PlanarRegion[] _planarRegions
     (write-long (length _planarRegions) s)
     (dolist (elem _planarRegions)
       (send elem :serialize s)
       )
     ;; grid_map_msgs/GridMap _gridmap
       (send _gridmap :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; convex_plane_decomposition_msgs/PlanarRegion[] _planarRegions
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _planarRegions (let (r) (dotimes (i n) (push (instance convex_plane_decomposition_msgs::PlanarRegion :init) r)) r))
     (dolist (elem- _planarRegions)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;; grid_map_msgs/GridMap _gridmap
     (send _gridmap :deserialize buf ptr-) (incf ptr- (send _gridmap :serialization-length))
   ;;
   self)
  )

(setf (get convex_plane_decomposition_msgs::PlanarTerrain :md5sum-) "081e702fce247ef5685dd96b39e3dfd4")
(setf (get convex_plane_decomposition_msgs::PlanarTerrain :datatype-) "convex_plane_decomposition_msgs/PlanarTerrain")
(setf (get convex_plane_decomposition_msgs::PlanarTerrain :definition-)
      "PlanarRegion[] planarRegions
grid_map_msgs/GridMap gridmap
================================================================================
MSG: convex_plane_decomposition_msgs/PlanarRegion
geometry_msgs/Pose plane_parameters

BoundingBox2d bbox2d

PolygonWithHoles2d boundary

PolygonWithHoles2d[] insets

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w

================================================================================
MSG: convex_plane_decomposition_msgs/BoundingBox2d
# 3D, axis-aligned, bounding box
float32 min_x
float32 min_y
float32 max_x
float32 max_y
================================================================================
MSG: convex_plane_decomposition_msgs/PolygonWithHoles2d
# Specification of a 2D polygon with holes
Polygon2d outer_boundary
Polygon2d[] holes
================================================================================
MSG: convex_plane_decomposition_msgs/Polygon2d
# Specification of a 2D polygon where the first and last points are connected
Point2d[] points
================================================================================
MSG: convex_plane_decomposition_msgs/Point2d
float32 x
float32 y
================================================================================
MSG: grid_map_msgs/GridMap
# Grid map header
GridMapInfo info

# Grid map layer names.
string[] layers

# Grid map basic layer names (optional). The basic layers
# determine which layers from `layers` need to be valid
# in order for a cell of the grid map to be valid.
string[] basic_layers

# Grid map data.
std_msgs/Float32MultiArray[] data

# Row start index (default 0).
uint16 outer_start_index

# Column start index (default 0).
uint16 inner_start_index

================================================================================
MSG: grid_map_msgs/GridMapInfo
# Header (time and frame)
Header header

# Resolution of the grid [m/cell].
float64 resolution

# Length in x-direction [m].
float64 length_x

# Length in y-direction [m].
float64 length_y

# Pose of the grid map center in the frame defined in `header` [m].
geometry_msgs/Pose pose
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

================================================================================
MSG: std_msgs/Float32MultiArray
# Please look at the MultiArrayLayout message definition for
# documentation on all multiarrays.

MultiArrayLayout  layout        # specification of data layout
float32[]         data          # array of data


================================================================================
MSG: std_msgs/MultiArrayLayout
# The multiarray declares a generic multi-dimensional array of a
# particular data type.  Dimensions are ordered from outer most
# to inner most.

MultiArrayDimension[] dim # Array of dimension properties
uint32 data_offset        # padding elements at front of data

# Accessors should ALWAYS be written in terms of dimension stride
# and specified outer-most dimension first.
# 
# multiarray(i,j,k) = data[data_offset + dim_stride[1]*i + dim_stride[2]*j + k]
#
# A standard, 3-channel 640x480 image with interleaved color channels
# would be specified as:
#
# dim[0].label  = \"height\"
# dim[0].size   = 480
# dim[0].stride = 3*640*480 = 921600  (note dim[0] stride is just size of image)
# dim[1].label  = \"width\"
# dim[1].size   = 640
# dim[1].stride = 3*640 = 1920
# dim[2].label  = \"channel\"
# dim[2].size   = 3
# dim[2].stride = 3
#
# multiarray(i,j,k) refers to the ith row, jth column, and kth channel.

================================================================================
MSG: std_msgs/MultiArrayDimension
string label   # label of given dimension
uint32 size    # size of given dimension (in type units)
uint32 stride  # stride of given dimension
")



(provide :convex_plane_decomposition_msgs/PlanarTerrain "081e702fce247ef5685dd96b39e3dfd4")


