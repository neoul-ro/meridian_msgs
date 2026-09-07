# Development-stage tracklet carrying the fields the Local Graph design needs in
# addition to Tracklet.msg. Tracklet.msg stays unchanged for now; once the
# contract is settled with the frontend these fields move into Tracklet.msg and
# this type is removed.
#
# Publishing contract (Local Graph design, decision 1): one message per object
# episode, emitted when the object has left the field of view for the
# retirement gap; the same tracklet_id is never re-published.

uint32 tracklet_id                         # Tracker-assigned ID; not a graph-level identity
sensor_msgs/PointCloud2 tracklet_geometry  # World-frame cell centres of the episode's voxel set,
                                           # quantised on the `voxel_size` grid (floor, centre = (i+0.5)*voxel_size);
                                           # header.stamp = last contributing capture time (= last_seen)
float32[] tracklet_semantics               # Episode-averaged, L2-normalised embedding [embedding_dim];
                                           # empty when n_obs_embedded == 0
float32 voxel_size                         # Grid cell size in metres used for tracklet_geometry
builtin_interfaces/Time first_seen         # First contributing capture time
uint32 n_observations                      # Frames in the episode
uint32 n_obs_embedded                      # Frames that contributed to tracklet_semantics (semantic weight)
uint16 embedding_dim                       # Length of tracklet_semantics when non-empty
string embedding_model_id                  # Embedding model identifier (e.g. CLIP ViT-B/32)
