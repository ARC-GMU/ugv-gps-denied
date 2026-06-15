;; Auto-generated. Do not edit!


(when (boundp 'convex_plane_decomposition_msgs::PlanarRegion)
  (if (not (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
    (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
  (shadow 'PlanarRegion (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS")))
(unless (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS::PLANARREGION")
  (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS::PLANARREGION"))

(in-package "ROS")
;;//! \htmlinclude PlanarRegion.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass convex_plane_decomposition_msgs::PlanarRegion
  :super ros::object
  :slots (_plane_parameters _bbox2d _boundary _insets ))

(defmethod convex_plane_decomposition_msgs::PlanarRegion
  (:init
   (&key
    ((:plane_parameters __plane_parameters) (instance geometry_msgs::Pose :init))
    ((:bbox2d __bbox2d) (instance convex_plane_decomposition_msgs::BoundingBox2d :init))
    ((:boundary __boundary) (instance convex_plane_decomposition_msgs::PolygonWithHoles2d :init))
    ((:insets __insets) ())
    )
   (send-super :init)
   (setq _plane_parameters __plane_parameters)
   (setq _bbox2d __bbox2d)
   (setq _boundary __boundary)
   (setq _insets __insets)
   self)
  (:plane_parameters
   (&rest __plane_parameters)
   (if (keywordp (car __plane_parameters))
       (send* _plane_parameters __plane_parameters)
     (progn
       (if __plane_parameters (setq _plane_parameters (car __plane_parameters)))
       _plane_parameters)))
  (:bbox2d
   (&rest __bbox2d)
   (if (keywordp (car __bbox2d))
       (send* _bbox2d __bbox2d)
     (progn
       (if __bbox2d (setq _bbox2d (car __bbox2d)))
       _bbox2d)))
  (:boundary
   (&rest __boundary)
   (if (keywordp (car __boundary))
       (send* _boundary __boundary)
     (progn
       (if __boundary (setq _boundary (car __boundary)))
       _boundary)))
  (:insets
   (&rest __insets)
   (if (keywordp (car __insets))
       (send* _insets __insets)
     (progn
       (if __insets (setq _insets (car __insets)))
       _insets)))
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/Pose _plane_parameters
    (send _plane_parameters :serialization-length)
    ;; convex_plane_decomposition_msgs/BoundingBox2d _bbox2d
    (send _bbox2d :serialization-length)
    ;; convex_plane_decomposition_msgs/PolygonWithHoles2d _boundary
    (send _boundary :serialization-length)
    ;; convex_plane_decomposition_msgs/PolygonWithHoles2d[] _insets
    (apply #'+ (send-all _insets :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/Pose _plane_parameters
       (send _plane_parameters :serialize s)
     ;; convex_plane_decomposition_msgs/BoundingBox2d _bbox2d
       (send _bbox2d :serialize s)
     ;; convex_plane_decomposition_msgs/PolygonWithHoles2d _boundary
       (send _boundary :serialize s)
     ;; convex_plane_decomposition_msgs/PolygonWithHoles2d[] _insets
     (write-long (length _insets) s)
     (dolist (elem _insets)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/Pose _plane_parameters
     (send _plane_parameters :deserialize buf ptr-) (incf ptr- (send _plane_parameters :serialization-length))
   ;; convex_plane_decomposition_msgs/BoundingBox2d _bbox2d
     (send _bbox2d :deserialize buf ptr-) (incf ptr- (send _bbox2d :serialization-length))
   ;; convex_plane_decomposition_msgs/PolygonWithHoles2d _boundary
     (send _boundary :deserialize buf ptr-) (incf ptr- (send _boundary :serialization-length))
   ;; convex_plane_decomposition_msgs/PolygonWithHoles2d[] _insets
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _insets (let (r) (dotimes (i n) (push (instance convex_plane_decomposition_msgs::PolygonWithHoles2d :init) r)) r))
     (dolist (elem- _insets)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get convex_plane_decomposition_msgs::PlanarRegion :md5sum-) "8cff8c52c8273f12e2fd17b9d4a3d417")
(setf (get convex_plane_decomposition_msgs::PlanarRegion :datatype-) "convex_plane_decomposition_msgs/PlanarRegion")
(setf (get convex_plane_decomposition_msgs::PlanarRegion :definition-)
      "geometry_msgs/Pose plane_parameters

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
")



(provide :convex_plane_decomposition_msgs/PlanarRegion "8cff8c52c8273f12e2fd17b9d4a3d417")


