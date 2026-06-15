
(cl:in-package :asdf)

(defsystem "convex_plane_decomposition_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :grid_map_msgs-msg
)
  :components ((:file "_package")
    (:file "BoundingBox2d" :depends-on ("_package_BoundingBox2d"))
    (:file "_package_BoundingBox2d" :depends-on ("_package"))
    (:file "PlanarRegion" :depends-on ("_package_PlanarRegion"))
    (:file "_package_PlanarRegion" :depends-on ("_package"))
    (:file "PlanarTerrain" :depends-on ("_package_PlanarTerrain"))
    (:file "_package_PlanarTerrain" :depends-on ("_package"))
    (:file "Point2d" :depends-on ("_package_Point2d"))
    (:file "_package_Point2d" :depends-on ("_package"))
    (:file "Polygon2d" :depends-on ("_package_Polygon2d"))
    (:file "_package_Polygon2d" :depends-on ("_package"))
    (:file "PolygonWithHoles2d" :depends-on ("_package_PolygonWithHoles2d"))
    (:file "_package_PolygonWithHoles2d" :depends-on ("_package"))
  ))