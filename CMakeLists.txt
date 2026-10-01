cmake_minimum_required(VERSION 3.8)
project(meridian_msgs)

find_package(ament_cmake REQUIRED)
find_package(builtin_interfaces REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)

set(msg_files
  "msg/TrackletDev.msg"
  "msg/GraphUpdateEventDev.msg"
  "msg/CandidateScoreDev.msg"
  "msg/DuplicateSuspectDev.msg"
  "msg/MergeVerificationDev.msg"
  "msg/AssociationDecisionDev.msg"
  "msg/AssociationDecisionSetDev.msg"
  "msg/FrameStatus.msg"
)

set(srv_files
  "srv/GetGraph.srv"
  "srv/SaveGraph.srv"
  "srv/QueryByEmbedding.srv"
)

rosidl_generate_interfaces(${PROJECT_NAME}
  ${msg_files}
  ${srv_files}
  DEPENDENCIES
    builtin_interfaces
    geometry_msgs
    sensor_msgs
    std_msgs
)

ament_export_dependencies(rosidl_default_runtime)
ament_package()
