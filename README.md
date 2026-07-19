# meridian_msgs

ROS 2 Humble interface package for Meridian runtime dataflow contracts.

## Type mapping

| Runtime type | ROS 2 representation |
| --- | --- |
| `cv::Mat` image | `sensor_msgs/Image` |
| `Eigen::Isometry3d` | `geometry_msgs/PoseWithCovariance` |
| `Eigen::Vector3f` point | `geometry_msgs/Point` |
| `Eigen::Vector3f` extent | `geometry_msgs/Vector3` |
| `Eigen::Matrix<float, 3, Dynamic>` | `sensor_msgs/PointCloud2` |
| `torch::Tensor [N, D]` | row-major `float32[]` with `embedding_dim` |
| `std::optional<T>` | `bool has_*` followed by the value field |
| `std::unordered_map<object_id, ObjectNode>` | `ObjectNode[]` with unique `object_id` |

## Message groups

- Sensor and perception: `RGBDFrame`, `SegmentImage`, `PoseEstimate`,
  `InstanceEmbeddingSet`, `Instance3D`, `Instance3DSet`
- Frontend tracking: `SegmentRef`, `TrackletGeometry`, `TrackletSemantics`,
  `EmbeddedTracklet`, `EmbeddedTrackletSet`
- Data association: `AssociationDecision`, `AssociationDecisionSet`
- Persistent state: `ObjectGeometryState`, `ObjectSemanticState`, `ObjectState`
- Graph update: `ObjectMutation`, `ObjectMutationSet`, `ObjectNode`,
  `LocalObjectGraphSnapshot`, `ObjectChange`, `GraphUpdateEvent`

## Contract invariants

- `RGBDFrame.rgb` uses `rgb8`; `depth_m` uses `32FC1` in meters.
- `SegmentImage.labels` uses `mono8`. Value `0` is background and values
  `1..255` are frame-local segment IDs.
- `InstanceEmbeddingSet.embeddings` is row-major `[N, D]`, where
  `N == segment_ids.size()` and `D == embedding_dim`.
- For an `EmbeddedTracklet`, `source_segments`,
  `geometry.point_clouds_world_m`, and the semantic embedding rows describe
  the same ordered observations.
- `EmbeddedTrackletSet` is the complete snapshot for one rolling window, not a
  delta. Repeated `SegmentRef` evidence must be merged idempotently.
- `AssociationDecisionSet` and `ObjectMutationSet` carry the graph version on
  which they were computed.
- A `MATCH` decision requires `has_matched_object_id == true`; other outcomes
  require it to be false.
- A `CREATE` mutation requires `has_target_object_id == false`; an `UPDATE`
  mutation requires it to be true.
- Point clouds and geometry fields are expressed in the world frame. Each
  `PointCloud2.header.frame_id` must agree with the active graph world frame.
- Runtime messages contain no benchmark-only ground-truth fields.

The persistent geometry update, semantic aggregation, score calibration, and
association policies remain algorithm-level decisions outside this interface
package.
