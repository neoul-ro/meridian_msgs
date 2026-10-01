# meridian_msgs

ROS 2 Humble messages and services that connect the Meridian modules. Camera images, camera info and
poses use standard types (`sensor_msgs/Image`, `sensor_msgs/CameraInfo`, `geometry_msgs/PoseStamped`);
this package defines only the Meridian-specific ones.

## Where it sits

```
meridian pipeline_node --/tracklet (TrackletDev)--> graphcore_node --/graph_update_event (GraphUpdateEventDev)--> replicas, gt_evaluator
          └── /meridian/frame_status (FrameStatus) --> dataset_publisher (lockstep), gt_evaluator
graphcore_node services: /get_graph, /save_graph, /query_by_embedding
```

## Quick start

```bash
source /opt/ros/humble/setup.bash
cd <workspace> && colcon build --packages-select meridian_msgs
source install/setup.bash
ros2 interface show meridian_msgs/msg/TrackletDev
```

Checked on 2026-10-01 (x86-64, ROS 2 Humble).

## Messages and services

| Type | Topic | Published by | Read by |
|---|---|---|---|
| `TrackletDev` | `/tracklet` | `meridian` pipeline node, one per DA object update | `graphcore_node` |
| `GraphUpdateEventDev` | `/graph_update_event` | `graphcore_node`, one per commit, plus heartbeats | graph replicas, `gt_evaluator` |
| `FrameStatus` | `/meridian/frame_status` | `meridian` pipeline node, one per input frame | `dataset_publisher` (lockstep), `gt_evaluator` |
| `AssociationDecisionSetDev` (+ `AssociationDecisionDev`, `CandidateScoreDev`, `DuplicateSuspectDev`, `MergeVerificationDev`) | `/association_decision_set` | `graphcore_node` with `debug_decisions` | DA benchmarking |

| Service | Server | Use |
|---|---|---|
| `GetGraph` (`/get_graph`) | `graphcore_node` | Full graph or the changes since a version (Spark-DSG binary) |
| `SaveGraph` (`/save_graph`) | `graphcore_node` | Write the graph to a Spark-DSG file |
| `QueryByEmbedding` (`/query_by_embedding`) | `graphcore_node` | Nearest objects to an embedding (the caller turns text into the embedding) |

The frontend's own keyframe message `TrackletSet` is in `meridian_frontend_msgs`, not here.

## Rules every user should know

- `object_id` is the only stable identity. `tracklet_id` is unique per `TrackletDev` message (graphcore's
  commit key), not an identity.
- `TrackletDev.external_object_id` / `merged_external_object_ids` carry an upstream DA's identity and merges
  (0 / empty = none). Only `graphcore_node` with `association_source: external` reads them.
- Points and geometry are in the world frame; `PointCloud2.header.frame_id` must match the graph's world frame.
- Integer widths: `object_id` / `tracklet_id` are `uint32`, `graph_version` is `uint64`, `embedding_dim` is `uint16`.
- Runtime messages carry no ground-truth fields.

## Common problems

| Symptom | Cause / fix |
|---|---|
| A subscriber receives nothing, with no error | ROS 2 matches publisher and subscriber by type as well as name. Check `ros2 topic info -v <topic>` for the type on each side. |
| `ros2 interface show` cannot find a type | Source the workspace (`source install/setup.bash`) after building this package. |

## More

- Field-level contracts: the comments in `msg/*.msg` and `srv/*.srv`
- Former README (robot pose topics `/pose` and `/pose_cov`, removed v0.0.2 messages, full invariants): [docs/msgs/REFERENCE.md](https://github.com/neoul-ro/meridian/blob/main/docs/msgs/REFERENCE.md)
- Event and service semantics: [meridian_graphcore](https://github.com/neoul-ro/meridian_graphcore)
- The whole pipeline: [neoul-ro/meridian](https://github.com/neoul-ro/meridian)
