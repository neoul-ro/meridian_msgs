# One frontend tracklet: a short-term object hypothesis accumulated by the
# Geometry Tracker over recent frames.
uint32 tracklet_id                         # Tracker-assigned ID, persistent across TrackletSet snapshots;
                                           # not a graph-level identity (stable identity is object_id only)
sensor_msgs/PointCloud2 tracklet_geometry  # Merged world-frame cloud of all contributing observations;
                                           # header.stamp is the latest contributing capture time
float32[] tracklet_semantics               # Aggregated semantic embedding [D] accumulated from
                                           # instance embeddings; aggregation method TBD
