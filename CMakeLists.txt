cmake_minimum_required(VERSION 3.8)
project(meridian_msgs)

find_package(ament_cmake REQUIRED)
find_package(builtin_interfaces REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(sensor_msgs REQUIRED)

set(msg_files
  "msg/AssociationDecision.msg"
  "msg/AssociationDecisionSet.msg"
  "msg/EmbeddedTracklet.msg"
  "msg/EmbeddedTrackletSet.msg"
  "msg/GraphUpdateEvent.msg"
  "msg/Instance3D.msg"
  "msg/Instance3DSet.msg"
  "msg/InstanceEmbeddingSet.msg"
  "msg/LocalObjectGraphSnapshot.msg"
  "msg/ObjectChange.msg"
  "msg/ObjectGeometryState.msg"
  "msg/ObjectMutation.msg"
  "msg/ObjectMutationSet.msg"
  "msg/ObjectNode.msg"
  "msg/ObjectSemanticState.msg"
  "msg/ObjectState.msg"
  "msg/PoseEstimate.msg"
  "msg/RGBDFrame.msg"
  "msg/SegmentImage.msg"
  "msg/SegmentRef.msg"
  "msg/TrackletGeometry.msg"
  "msg/TrackletSemantics.msg"
)

rosidl_generate_interfaces(${PROJECT_NAME}
  ${msg_files}
  DEPENDENCIES
    builtin_interfaces
    geometry_msgs
    sensor_msgs
)

ament_export_dependencies(rosidl_default_runtime)
ament_package()
