# meridian_msgs

The ROS 2 messages and services that Meridian's modules talk through. If you write a node that feeds
the object graph, reads it, or replays it, these types and the rules below are the contract you code
against. Camera images, camera info and poses use the standard ROS types; only the Meridian-specific
ones live here.

```
pipeline_node ──/tracklet (TrackletDev): "object X now looks like this"──▶ graphcore_node
pipeline_node ──/meridian/frame_status (FrameStatus): "frame done"──▶ player, evaluator
graphcore_node ──/graph_update_event (GraphUpdateEventDev): "graph changed, here is the delta"──▶ any reader
any reader ──/get_graph · /save_graph · /query_by_embedding──▶ graphcore_node
```

## The rules

1. **`object_id` is the only stable identity.** `tracklet_id` is just a unique number per
   `TrackletDev` message (graphcore uses it as the commit key); never use it to recognise an object.
2. **Identity can come from upstream.** `TrackletDev.external_object_id` is the id an upstream data
   association decided (0 = none), and `merged_external_object_ids` lists ids it merged into that one.
   Only `graphcore_node` with `association_source: external` reads them; then each message is the
   object's complete current geometry and replaces the previous one.
3. **Geometry is a voxel set in the world frame.** `tracklet_geometry` holds cell centres on the
   `voxel_size` grid (centre = `(i + 0.5) * voxel_size`), and `voxel_size` must equal the graph's
   (graphcore rejects other grids). `header.frame_id` must be the graph's world frame.
4. **Graph events are deltas; you keep a replica.** Each `GraphUpdateEventDev` carries a Spark-DSG
   blob with only the changed node, plus `merged_from` / `removed_object_ids` for nodes that left.
   Follow the order rules: a new `graph_epoch` means start over with `GetGraph{0, 0}`; a gap in
   `graph_version` or a `state_hash` mismatch means ask `GetGraph` for the changes since your
   version. Heartbeats (`is_heartbeat: true`) carry no change.
5. **Widths are fixed:** `object_id` / `tracklet_id` are `uint32`, `graph_version` is `uint64`,
   `embedding_dim` is `uint16`. Runtime messages carry no ground-truth fields.

The field-by-field contract is in the comments of [`msg/`](msg) and [`srv/`](srv); read them before
publishing.

## Example: publish one TrackletDev

Build and look at the package:

```bash
source /opt/ros/humble/setup.bash
colcon build --packages-select meridian_msgs && source install/setup.bash
ros2 interface package meridian_msgs        # 8 messages, 3 services
```

A minimal publisher (Python, run with `python3 pub_tracklet.py`):

```python
import rclpy
from std_msgs.msg import Header
from sensor_msgs_py.point_cloud2 import create_cloud_xyz32
from meridian_msgs.msg import TrackletDev

rclpy.init(); node = rclpy.create_node('tracklet_pub')
pub = node.create_publisher(TrackletDev, '/tracklet', 10)
t = TrackletDev(tracklet_id=42, voxel_size=0.02, n_observations=3, external_object_id=7)
t.tracklet_geometry = create_cloud_xyz32(          # world-frame cell centres: (i + 0.5) * voxel_size
    Header(frame_id='map', stamp=node.get_clock().now().to_msg()), [[0.01, 0.01, 0.01], [0.03, 0.01, 0.01]])
while pub.get_subscription_count() == 0: rclpy.spin_once(node, timeout_sec=0.1)
pub.publish(t)
```

In another shell, `ros2 topic echo --once --no-arr /tracklet meridian_msgs/msg/TrackletDev` prints
(trimmed):

```
tracklet_id: 42
tracklet_geometry:
  header:
    stamp: ...
    frame_id: map
  height: 1
  width: 2
  ...
voxel_size: 0.019999999552965164
n_observations: 3
n_obs_embedded: 0
external_object_id: 7
merged_external_object_ids: '<sequence type: uint32, length: 0>'
```

With `graphcore_node` running, the same message becomes a graph node; see the
[meridian_graphcore](https://github.com/neoul-ro/meridian_graphcore) example.

## What is in the package

| Type | Topic / service | Sent by → read by |
|---|---|---|
| `TrackletDev` | `/tracklet` | `meridian` pipeline node (one per object update) → `graphcore_node` |
| `GraphUpdateEventDev` | `/graph_update_event` | `graphcore_node` (one per commit, plus heartbeats) → replicas, `gt_evaluator` |
| `FrameStatus` | `/meridian/frame_status` | pipeline node (one per input frame) → `dataset_publisher` in lockstep, `gt_evaluator` |
| `AssociationDecisionSetDev` (+ `AssociationDecisionDev`, `CandidateScoreDev`, `DuplicateSuspectDev`, `MergeVerificationDev`) | `/association_decision_set` | `graphcore_node` with `debug_decisions: true` → DA benchmarking |
| `GetGraph` | `/get_graph` | whole graph, or the changes since a version (paged) |
| `SaveGraph` | `/save_graph` | write the graph to a Spark-DSG file on the node's host |
| `QueryByEmbedding` | `/query_by_embedding` | nearest objects to an embedding (you turn text into the embedding) |

The `Dev` suffix marks types that may still change. The frontend's keyframe message `TrackletSet`
lives in `meridian_frontend_msgs`, not here.

If a subscriber silently receives nothing, compare the type on both sides with
`ros2 topic info -v <topic>`: ROS 2 matches topics by type as well as name.

## More

- How graphcore uses the events and services: [meridian_graphcore](https://github.com/neoul-ro/meridian_graphcore)
- Former README (robot pose topics, removed v0.0.2 messages, full invariants): [docs/msgs/REFERENCE.md](https://github.com/neoul-ro/meridian/blob/main/docs/msgs/REFERENCE.md)
- The whole pipeline: [neoul-ro/meridian](https://github.com/neoul-ro/meridian)
