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

# Object identity decided upstream (optional; added 2026-09-30). Read only by a
# graphcore_node running with `association_source: external`, which then skips its
# own association and follows these ids; `internal` (the default) ignores both
# fields, so a publisher that leaves them unset behaves exactly as before.
# In that mode one message is one update of one upstream object (not an episode):
# tracklet_geometry is the object's complete current voxel set and replaces the
# node's geometry. tracklet_id stays unique per message (it is the commit key).
uint32 external_object_id                  # Upstream DA's stable object id; 0 = none
uint32[] merged_external_object_ids        # Upstream ids the DA merged into external_object_id
                                           # (at or before this update); their nodes are merged
                                           # into its node before the update is applied
