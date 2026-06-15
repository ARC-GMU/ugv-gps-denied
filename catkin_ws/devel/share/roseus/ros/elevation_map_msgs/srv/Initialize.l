;; Auto-generated. Do not edit!


(when (boundp 'elevation_map_msgs::Initialize)
  (if (not (find-package "ELEVATION_MAP_MSGS"))
    (make-package "ELEVATION_MAP_MSGS"))
  (shadow 'Initialize (find-package "ELEVATION_MAP_MSGS")))
(unless (find-package "ELEVATION_MAP_MSGS::INITIALIZE")
  (make-package "ELEVATION_MAP_MSGS::INITIALIZE"))
(unless (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST")
  (make-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(unless (find-package "ELEVATION_MAP_MSGS::INITIALIZERESPONSE")
  (make-package "ELEVATION_MAP_MSGS::INITIALIZERESPONSE"))

(in-package "ROS")

(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))




(intern "*POINTS*" (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(shadow '*POINTS* (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(defconstant elevation_map_msgs::InitializeRequest::*POINTS* 0)
(intern "*NEAREST*" (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(shadow '*NEAREST* (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(defconstant elevation_map_msgs::InitializeRequest::*NEAREST* 0)
(intern "*LINEAR*" (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(shadow '*LINEAR* (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(defconstant elevation_map_msgs::InitializeRequest::*LINEAR* 1)
(intern "*CUBIC*" (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(shadow '*CUBIC* (find-package "ELEVATION_MAP_MSGS::INITIALIZEREQUEST"))
(defconstant elevation_map_msgs::InitializeRequest::*CUBIC* 2)

(defun elevation_map_msgs::InitializeRequest-to-symbol (const)
  (cond
        ((= const 0) 'elevation_map_msgs::InitializeRequest::*POINTS*)
        ((= const 0) 'elevation_map_msgs::InitializeRequest::*NEAREST*)
        ((= const 1) 'elevation_map_msgs::InitializeRequest::*LINEAR*)
        ((= const 2) 'elevation_map_msgs::InitializeRequest::*CUBIC*)
        (t nil)))

(defclass elevation_map_msgs::InitializeRequest
  :super ros::object
  :slots (_type _method _points ))

(defmethod elevation_map_msgs::InitializeRequest
  (:init
   (&key
    ((:type __type) 0)
    ((:method __method) 0)
    ((:points __points) ())
    )
   (send-super :init)
   (setq _type (round __type))
   (setq _method (round __method))
   (setq _points __points)
   self)
  (:type
   (&optional __type)
   (if __type (setq _type __type)) _type)
  (:method
   (&optional __method)
   (if __method (setq _method __method)) _method)
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
    ;; uint8 _type
    1
    ;; uint8 _method
    1
    ;; geometry_msgs/PointStamped[] _points
    (apply #'+ (send-all _points :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _type
       (write-byte _type s)
     ;; uint8 _method
       (write-byte _method s)
     ;; geometry_msgs/PointStamped[] _points
     (write-long (length _points) s)
     (dolist (elem _points)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _type
     (setq _type (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _method
     (setq _method (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; geometry_msgs/PointStamped[] _points
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _points (let (r) (dotimes (i n) (push (instance geometry_msgs::PointStamped :init) r)) r))
     (dolist (elem- _points)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(defclass elevation_map_msgs::InitializeResponse
  :super ros::object
  :slots (_success ))

(defmethod elevation_map_msgs::InitializeResponse
  (:init
   (&key
    ((:success __success) nil)
    )
   (send-super :init)
   (setq _success __success)
   self)
  (:success
   (&optional (__success :null))
   (if (not (eq __success :null)) (setq _success __success)) _success)
  (:serialization-length
   ()
   (+
    ;; bool _success
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _success
       (if _success (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _success
     (setq _success (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass elevation_map_msgs::Initialize
  :super ros::object
  :slots ())

(setf (get elevation_map_msgs::Initialize :md5sum-) "2132848049aeee984c2fb7de662fe983")
(setf (get elevation_map_msgs::Initialize :datatype-) "elevation_map_msgs/Initialize")
(setf (get elevation_map_msgs::Initialize :request) elevation_map_msgs::InitializeRequest)
(setf (get elevation_map_msgs::Initialize :response) elevation_map_msgs::InitializeResponse)

(defmethod elevation_map_msgs::InitializeRequest
  (:response () (instance elevation_map_msgs::InitializeResponse :init)))

(setf (get elevation_map_msgs::InitializeRequest :md5sum-) "2132848049aeee984c2fb7de662fe983")
(setf (get elevation_map_msgs::InitializeRequest :datatype-) "elevation_map_msgs/InitializeRequest")
(setf (get elevation_map_msgs::InitializeRequest :definition-)
      "# Initialization methods
# TODO add more methods.
uint8 POINTS=0

uint8 NEAREST=0
uint8 LINEAR=1
uint8 CUBIC=2

uint8 type
uint8 method
geometry_msgs/PointStamped[] points


================================================================================
MSG: geometry_msgs/PointStamped
# This represents a Point with reference coordinate frame and timestamp
Header header
Point point

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
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z
---
bool success

")

(setf (get elevation_map_msgs::InitializeResponse :md5sum-) "2132848049aeee984c2fb7de662fe983")
(setf (get elevation_map_msgs::InitializeResponse :datatype-) "elevation_map_msgs/InitializeResponse")
(setf (get elevation_map_msgs::InitializeResponse :definition-)
      "# Initialization methods
# TODO add more methods.
uint8 POINTS=0

uint8 NEAREST=0
uint8 LINEAR=1
uint8 CUBIC=2

uint8 type
uint8 method
geometry_msgs/PointStamped[] points


================================================================================
MSG: geometry_msgs/PointStamped
# This represents a Point with reference coordinate frame and timestamp
Header header
Point point

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
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z
---
bool success

")



(provide :elevation_map_msgs/Initialize "2132848049aeee984c2fb7de662fe983")


