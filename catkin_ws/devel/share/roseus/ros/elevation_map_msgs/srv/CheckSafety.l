;; Auto-generated. Do not edit!


(when (boundp 'elevation_map_msgs::CheckSafety)
  (if (not (find-package "ELEVATION_MAP_MSGS"))
    (make-package "ELEVATION_MAP_MSGS"))
  (shadow 'CheckSafety (find-package "ELEVATION_MAP_MSGS")))
(unless (find-package "ELEVATION_MAP_MSGS::CHECKSAFETY")
  (make-package "ELEVATION_MAP_MSGS::CHECKSAFETY"))
(unless (find-package "ELEVATION_MAP_MSGS::CHECKSAFETYREQUEST")
  (make-package "ELEVATION_MAP_MSGS::CHECKSAFETYREQUEST"))
(unless (find-package "ELEVATION_MAP_MSGS::CHECKSAFETYRESPONSE")
  (make-package "ELEVATION_MAP_MSGS::CHECKSAFETYRESPONSE"))

(in-package "ROS")

(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass elevation_map_msgs::CheckSafetyRequest
  :super ros::object
  :slots (_polygons _compute_untraversable_polygon ))

(defmethod elevation_map_msgs::CheckSafetyRequest
  (:init
   (&key
    ((:polygons __polygons) ())
    ((:compute_untraversable_polygon __compute_untraversable_polygon) nil)
    )
   (send-super :init)
   (setq _polygons __polygons)
   (setq _compute_untraversable_polygon __compute_untraversable_polygon)
   self)
  (:polygons
   (&rest __polygons)
   (if (keywordp (car __polygons))
       (send* _polygons __polygons)
     (progn
       (if __polygons (setq _polygons (car __polygons)))
       _polygons)))
  (:compute_untraversable_polygon
   (&optional (__compute_untraversable_polygon :null))
   (if (not (eq __compute_untraversable_polygon :null)) (setq _compute_untraversable_polygon __compute_untraversable_polygon)) _compute_untraversable_polygon)
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/PolygonStamped[] _polygons
    (apply #'+ (send-all _polygons :serialization-length)) 4
    ;; bool _compute_untraversable_polygon
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/PolygonStamped[] _polygons
     (write-long (length _polygons) s)
     (dolist (elem _polygons)
       (send elem :serialize s)
       )
     ;; bool _compute_untraversable_polygon
       (if _compute_untraversable_polygon (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/PolygonStamped[] _polygons
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _polygons (let (r) (dotimes (i n) (push (instance geometry_msgs::PolygonStamped :init) r)) r))
     (dolist (elem- _polygons)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;; bool _compute_untraversable_polygon
     (setq _compute_untraversable_polygon (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass elevation_map_msgs::CheckSafetyResponse
  :super ros::object
  :slots (_is_safe _traversability _untraversable_polygons ))

(defmethod elevation_map_msgs::CheckSafetyResponse
  (:init
   (&key
    ((:is_safe __is_safe) (let (r) (dotimes (i 0) (push nil r)) r))
    ((:traversability __traversability) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:untraversable_polygons __untraversable_polygons) ())
    )
   (send-super :init)
   (setq _is_safe __is_safe)
   (setq _traversability __traversability)
   (setq _untraversable_polygons __untraversable_polygons)
   self)
  (:is_safe
   (&optional __is_safe)
   (if __is_safe (setq _is_safe __is_safe)) _is_safe)
  (:traversability
   (&optional __traversability)
   (if __traversability (setq _traversability __traversability)) _traversability)
  (:untraversable_polygons
   (&rest __untraversable_polygons)
   (if (keywordp (car __untraversable_polygons))
       (send* _untraversable_polygons __untraversable_polygons)
     (progn
       (if __untraversable_polygons (setq _untraversable_polygons (car __untraversable_polygons)))
       _untraversable_polygons)))
  (:serialization-length
   ()
   (+
    ;; bool[] _is_safe
    (* 1    (length _is_safe)) 4
    ;; float64[] _traversability
    (* 8    (length _traversability)) 4
    ;; geometry_msgs/PolygonStamped[] _untraversable_polygons
    (apply #'+ (send-all _untraversable_polygons :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool[] _is_safe
     (write-long (length _is_safe) s)
     (dotimes (i (length _is_safe))
       (if (elt _is_safe i) (write-byte -1 s) (write-byte 0 s))
       )
     ;; float64[] _traversability
     (write-long (length _traversability) s)
     (dotimes (i (length _traversability))
       (sys::poke (elt _traversability i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; geometry_msgs/PolygonStamped[] _untraversable_polygons
     (write-long (length _untraversable_polygons) s)
     (dolist (elem _untraversable_polygons)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool[] _is_safe
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _is_safe (make-list n))
     (dotimes (i n)
     (setf (elt _is_safe i) (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
     ))
   ;; float64[] _traversability
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _traversability (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _traversability i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     ))
   ;; geometry_msgs/PolygonStamped[] _untraversable_polygons
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _untraversable_polygons (let (r) (dotimes (i n) (push (instance geometry_msgs::PolygonStamped :init) r)) r))
     (dolist (elem- _untraversable_polygons)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(defclass elevation_map_msgs::CheckSafety
  :super ros::object
  :slots ())

(setf (get elevation_map_msgs::CheckSafety :md5sum-) "137df6a3ff37546adfad4f1d40e233b4")
(setf (get elevation_map_msgs::CheckSafety :datatype-) "elevation_map_msgs/CheckSafety")
(setf (get elevation_map_msgs::CheckSafety :request) elevation_map_msgs::CheckSafetyRequest)
(setf (get elevation_map_msgs::CheckSafety :response) elevation_map_msgs::CheckSafetyResponse)

(defmethod elevation_map_msgs::CheckSafetyRequest
  (:response () (instance elevation_map_msgs::CheckSafetyResponse :init)))

(setf (get elevation_map_msgs::CheckSafetyRequest :md5sum-) "137df6a3ff37546adfad4f1d40e233b4")
(setf (get elevation_map_msgs::CheckSafetyRequest :datatype-) "elevation_map_msgs/CheckSafetyRequest")
(setf (get elevation_map_msgs::CheckSafetyRequest :definition-)
      "# Polygons to check
geometry_msgs/PolygonStamped[] polygons
bool compute_untraversable_polygon

# Results

================================================================================
MSG: geometry_msgs/PolygonStamped
# This represents a Polygon with reference coordinate frame and timestamp
Header header
Polygon polygon

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
MSG: geometry_msgs/Polygon
#A specification of a polygon where the first and last points are assumed to be connected
Point32[] points

================================================================================
MSG: geometry_msgs/Point32
# This contains the position of a point in free space(with 32 bits of precision).
# It is recommeded to use Point wherever possible instead of Point32.  
# 
# This recommendation is to promote interoperability.  
#
# This message is designed to take up less space when sending
# lots of points at once, as in the case of a PointCloud.  

float32 x
float32 y
---
bool[] is_safe

# Estimate of the traversability of the path.
# Ranges from 0 to 1 where 0 means not traversable and 1 highly traversable.
float64[] traversability

# Polygons that are untraversable.
geometry_msgs/PolygonStamped[] untraversable_polygons


================================================================================
MSG: geometry_msgs/PolygonStamped
# This represents a Polygon with reference coordinate frame and timestamp
Header header
Polygon polygon

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
MSG: geometry_msgs/Polygon
#A specification of a polygon where the first and last points are assumed to be connected
Point32[] points

================================================================================
MSG: geometry_msgs/Point32
# This contains the position of a point in free space(with 32 bits of precision).
# It is recommeded to use Point wherever possible instead of Point32.  
# 
# This recommendation is to promote interoperability.  
#
# This message is designed to take up less space when sending
# lots of points at once, as in the case of a PointCloud.  

float32 x
float32 y
")

(setf (get elevation_map_msgs::CheckSafetyResponse :md5sum-) "137df6a3ff37546adfad4f1d40e233b4")
(setf (get elevation_map_msgs::CheckSafetyResponse :datatype-) "elevation_map_msgs/CheckSafetyResponse")
(setf (get elevation_map_msgs::CheckSafetyResponse :definition-)
      "# Polygons to check
geometry_msgs/PolygonStamped[] polygons
bool compute_untraversable_polygon

# Results

================================================================================
MSG: geometry_msgs/PolygonStamped
# This represents a Polygon with reference coordinate frame and timestamp
Header header
Polygon polygon

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
MSG: geometry_msgs/Polygon
#A specification of a polygon where the first and last points are assumed to be connected
Point32[] points

================================================================================
MSG: geometry_msgs/Point32
# This contains the position of a point in free space(with 32 bits of precision).
# It is recommeded to use Point wherever possible instead of Point32.  
# 
# This recommendation is to promote interoperability.  
#
# This message is designed to take up less space when sending
# lots of points at once, as in the case of a PointCloud.  

float32 x
float32 y
---
bool[] is_safe

# Estimate of the traversability of the path.
# Ranges from 0 to 1 where 0 means not traversable and 1 highly traversable.
float64[] traversability

# Polygons that are untraversable.
geometry_msgs/PolygonStamped[] untraversable_polygons


================================================================================
MSG: geometry_msgs/PolygonStamped
# This represents a Polygon with reference coordinate frame and timestamp
Header header
Polygon polygon

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
MSG: geometry_msgs/Polygon
#A specification of a polygon where the first and last points are assumed to be connected
Point32[] points

================================================================================
MSG: geometry_msgs/Point32
# This contains the position of a point in free space(with 32 bits of precision).
# It is recommeded to use Point wherever possible instead of Point32.  
# 
# This recommendation is to promote interoperability.  
#
# This message is designed to take up less space when sending
# lots of points at once, as in the case of a PointCloud.  

float32 x
float32 y
")



(provide :elevation_map_msgs/CheckSafety "137df6a3ff37546adfad4f1d40e233b4")


