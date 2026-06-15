;; Auto-generated. Do not edit!


(when (boundp 'convex_plane_decomposition_msgs::Polygon2d)
  (if (not (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
    (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS"))
  (shadow 'Polygon2d (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS")))
(unless (find-package "CONVEX_PLANE_DECOMPOSITION_MSGS::POLYGON2D")
  (make-package "CONVEX_PLANE_DECOMPOSITION_MSGS::POLYGON2D"))

(in-package "ROS")
;;//! \htmlinclude Polygon2d.msg.html


(defclass convex_plane_decomposition_msgs::Polygon2d
  :super ros::object
  :slots (_points ))

(defmethod convex_plane_decomposition_msgs::Polygon2d
  (:init
   (&key
    ((:points __points) ())
    )
   (send-super :init)
   (setq _points __points)
   self)
  (:points
   (&rest __points)
   (if (keywordp (car __points))
       (send* _points __points)
     (progn
       (if __points (setq _points (car __points)))
       _points)))
  (:serialization-length
   ()
   (+
    ;; convex_plane_decomposition_msgs/Point2d[] _points
    (apply #'+ (send-all _points :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; convex_plane_decomposition_msgs/Point2d[] _points
     (write-long (length _points) s)
     (dolist (elem _points)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; convex_plane_decomposition_msgs/Point2d[] _points
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _points (let (r) (dotimes (i n) (push (instance convex_plane_decomposition_msgs::Point2d :init) r)) r))
     (dolist (elem- _points)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get convex_plane_decomposition_msgs::Polygon2d :md5sum-) "0083ddac30f807eeef29c66ffedb79c7")
(setf (get convex_plane_decomposition_msgs::Polygon2d :datatype-) "convex_plane_decomposition_msgs/Polygon2d")
(setf (get convex_plane_decomposition_msgs::Polygon2d :definition-)
      "# Specification of a 2D polygon where the first and last points are connected
Point2d[] points
================================================================================
MSG: convex_plane_decomposition_msgs/Point2d
float32 x
float32 y
")



(provide :convex_plane_decomposition_msgs/Polygon2d "0083ddac30f807eeef29c66ffedb79c7")


