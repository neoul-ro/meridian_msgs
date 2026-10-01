# meridian_msgs

ROS 2 Humble interface package for Meridian runtime dataflow contracts.
Sensor input, segmentation, and pose use standard types (`sensor_msgs/Image`,
`sensor_msgs/CameraInfo`, `geometry_msgs/PoseStamped`); this package defines
only the Meridian-specific messages.

The robot pose is published on two topics, and which one a consumer subscribes
to decides the type it must expect:

| Topic | Type | |
| --- | --- | --- |
| `/pose` | `geometry_msgs/PoseStamped` | the contract; `map` frame, `base_link` pose |
| `/pose_cov` | `geometry_msgs/PoseWithCovarianceStamped` | same pose, for consumers that need covariance |

Both carry the same stamp and the same pose. Subscribing to `/pose` with
`PoseWithCovarianceStamped` connects to nothing: ROS 2 matches publisher and
subscriber by type as well as name, so a mismatch is silent -- no error, no
data.

## Messages

| Type | Topic | Published by | Read by |
| --- | --- | --- | --- |
| `TrackletDev` | `/tracklet` | `meridian` pipeline node (one per DA object update) | `graphcore_node` |
| `GraphUpdateEventDev` | `/graph_update_event` | `graphcore_node` (one per commit, heartbeats) | graph replicas, `gt_evaluator` |
| `AssociationDecisionSetDev` (+ `AssociationDecisionDev`, `CandidateScoreDev`, `DuplicateSuspectDev`, `MergeVerificationDev`) | `/association_decision_set` | `graphcore_node` with `debug_decisions` | DA benchmarking |
| `FrameStatus` | `/meridian/frame_status` | `meridian` pipeline node (one per input frame) | `dataset_publisher` (lockstep), `gt_evaluator` |

| Service | Server |
| --- | --- |
| `GetGraph` (`/get_graph`), `SaveGraph` (`/save_graph`), `QueryByEmbedding` (`/query_by_embedding`) | `graphcore_node` |

The frontend's keyframe output (`TrackletSet`) lives in `meridian_frontend_msgs`, not here.
The v0.0.2 message set (`Tracklet`, `TrackletSet`, `SegmentRef`, `Instance3DSet`,
`InstanceEmbeddingSet`, `AssociationDecision(Set)`, `Object*`, `LocalObjectGraphSnapshot`,
`GraphUpdateEvent`) was removed on 2026-10-01: after the Python graphcore scaffold was
deleted nothing in the workspace published or subscribed to any of them. They are in the
git history if needed.

## Contract invariants

- Capture time is unique per frame within one sensor stream and is carried in
  `header.stamp` for header-bearing messages.
- `tracklet_id` is unique per `TrackletDev` message (it is graphcore's commit key) and is
  not a graph identity; stable identity is `object_id` only.
- Integer widths: `object_id`/`tracklet_id` are `uint32`, `graph_version` is `uint64`,
  `embedding_dim` is `uint16`.
- Point clouds and geometry fields are expressed in the world frame. Each
  `PointCloud2.header.frame_id` must agree with the active graph world frame.
- Runtime messages contain no benchmark-only ground-truth fields.
- `TrackletDev.external_object_id` / `merged_external_object_ids` (optional,
  2026-09-30) carry an upstream DA's object identity and its merges; 0 / empty
  means none. Only a graphcore_node with `association_source: external` reads
  them; `tracklet_id` stays unique per message either way.

The persistent geometry update, semantic aggregation, score calibration, and
association policies remain algorithm-level decisions outside this interface
package.
