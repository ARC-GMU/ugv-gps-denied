;; Auto-generated. Do not edit!


(when (boundp 'convex_plane_decomposition_msgs::PolygonWithHoles2d)
  (if (not (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
    (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
  (shadow 'PolygonWithHoles2d (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS")))
(unless (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS::POLYGONWITHHOLES2D")
  (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS::POLYGONWITHHOLES2D"))

(in-package "ROS")
;;//! \htmlinclude PolygonWithHoles2d.msg.html


(defclass convex_plane_decomposition_msgs::PolygonWithHoles2d
  :super ros::object
  :slots (_outer_boundary _holes ))

(defmethod convex_plane_decomposition_msgs::PolygonWithHoles2d
  (:init
   (&key
    ((:outer_boundary __outer_boundary) (instance convex_plane_decomposition_msgs::Polygon2d :init))
    ((:holes __holes) ())
    )
   (send-super :init)
   (setq _outer_boundary __outer_boundary)
   (setq _holes __holes)
   self)
  (:outer_boundary
   (&rest __outer_boundary)
   (if (keywordp (car __outer_boundary))
       (send* _outer_boundary __outer_boundary)
     (progn
       (if __outer_boundary (setq _outer_boundary (car __outer_boundary)))
       _outer_boundary)))
  (:holes
   (&rest __holes)
   (if (keywordp (car __holes))
       (send* _holes __holes)
     (progn
       (if __holes (setq _holes (car __holes)))
       _holes)))
  (:serialization-length
   ()
   (+
    ;; convex_plane_decomposition_msgs/Polygon2d _outer_boundary
    (send _outer_boundary :serialization-length)
    ;; convex_plane_decomposition_msgs/Polygon2d[] _holes
    (apply #'+ (send-all _holes :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; convex_plane_decomposition_msgs/Polygon2d _outer_boundary
       (send _outer_boundary :serialize s)
     ;; convex_plane_decomposition_msgs/Polygon2d[] _holes
     (write-long (length _holes) s)
     (dolist (elem _holes)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; convex_plane_decomposition_msgs/Polygon2d _outer_boundary
     (send _outer_boundary :deserialize buf ptr-) (incf ptr- (send _outer_boundary :serialization-length))
   ;; convex_plane_decomposition_msgs/Polygon2d[] _holes
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _holes (let (r) (dotimes (i n) (push (instance convex_plane_decomposition_msgs::Polygon2d :init) r)) r))
     (dolist (elem- _holes)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get convex_plane_decomposition_msgs::PolygonWithHoles2d :md5sum-) "62e09666eefc245f9ca3347875cb36cc")
(setf (get convex_plane_decomposition_msgs::PolygonWithHoles2d :datatype-) "convex_plane_decomposition_msgs/PolygonWithHoles2d")
(setf (get convex_plane_decomposition_msgs::PolygonWithHoles2d :definition-)
      "# Specification of a 2D polygon with holes
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



(provide :convex_plane_decomposition_msgs/PolygonWithHoles2d "62e09666eefc245f9ca3347875cb36cc")


