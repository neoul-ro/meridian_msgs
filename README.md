# meridian_msgs

ROS 2 Humble interface package for Meridian runtime dataflow contracts.
Sensor input, segmentation, and pose use standard types (`sensor_msgs/Image`,
`sensor_msgs/CameraInfo`, `geometry_msgs/PoseWithCovarianceStamped`); this
package defines only the Meridian-specific messages.

## Type mapping

| Runtime type | ROS 2 representation |
| --- | --- |
| `cv::Mat` image | `sensor_msgs/Image` |
| camera intrinsics | `sensor_msgs/CameraInfo` |
| `Eigen::Isometry3d` | `geometry_msgs/PoseWithCovarianceStamped` |
| `Eigen::Vector3f` point | `geometry_msgs/Point` |
| `Eigen::Vector3f` extent | `geometry_msgs/Vector3` |
| `Eigen::Matrix<float, 3, Dynamic>` | `sensor_msgs/PointCloud2` |
| `torch::Tensor [N, D]` | row-major `float32[]` with `embedding_dim` |
| `std::optional<T>` | `bool has_*` followed by the value field |
| `std::unordered_map<object_id, ObjectNode>` | `ObjectNode[]` with unique `object_id` |

## Message groups

- Perception: `InstanceEmbeddingSet`, `Instance3DSet`
- Frontend tracking: `SegmentRef`, `Tracklet`, `TrackletSet`
- Data association: `AssociationDecision`, `AssociationDecisionSet`
- Persistent state: `ObjectGeometryState`, `ObjectSemanticState`, `ObjectState`
- Graph update: `ObjectMutation`, `ObjectUpdateSet`, `ObjectNode`,
  `LocalObjectGraphSnapshot`, `ObjectChange`, `GraphUpdateEvent`

## Contract invariants

- Capture time is unique per frame within one sensor stream and is carried in
  `header.stamp` for header-bearing messages.
- `Instance3DSet.segment_ids` and `instance_points` are parallel arrays of the
  same size; `segment_ids[k]` labels `instance_points[k]`.
- `InstanceEmbeddingSet.embeddings` is row-major `[N, D]`, where
  `N == segment_ids.size()` and `D == embedding_dim`.
- `TrackletSet` is the complete snapshot of live tracklets at one frame, not a
  delta; consumers must not merge across snapshots.
- `tracklet_id` is persistent across snapshots within a session but is not a
  graph identity; stable identity is `object_id` only.
- Integer widths: `object_id`/`tracklet_id`/`graph_version` are `uint32`,
  `embedding_dim` is `uint16`, `segment_id` is `uint8`.
- `AssociationDecisionSet` and `ObjectUpdateSet` reference the source
  `TrackletSet` frame via `header.stamp` and carry the graph version on which
  they were computed.
- A `MATCH` decision requires `has_matched_object_id == true`; other outcomes
  require it to be false.
- A `CREATE` mutation uses `target_object_id == 0`. `UPDATE` and `DELETE`
  require an existing non-zero `target_object_id`.
- `ObjectMutation.proposed_state` is ignored for `DELETE`.
- Point clouds and geometry fields are expressed in the world frame. Each
  `PointCloud2.header.frame_id` must agree with the active graph world frame.
- Runtime messages contain no benchmark-only ground-truth fields.

The persistent geometry update, semantic aggregation, score calibration, and
association policies remain algorithm-level decisions outside this interface
package.
