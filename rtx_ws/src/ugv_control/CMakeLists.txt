cmake_minimum_required(VERSION 3.0.2)
project(ackermann_costmap_planner)

find_package(catkin REQUIRED COMPONENTS
  rospy
  nav_msgs
  geometry_msgs
  tf
)

catkin_package()

catkin_install_python(PROGRAMS
  src/ackermann_costmap_planner.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)