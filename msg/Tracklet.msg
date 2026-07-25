# One frontend tracklet: a short-term object hypothesis accumulated by the
# Geometry Tracker over its rolling window.
uint64 tracklet_id                          # Tracker-assigned ID, persistent across TrackletSet snapshots;
                                            # not a graph-level identity (stable identity is object_id only)
sensor_msgs/PointCloud2[] tracklet_geometry # One world-frame partial cloud per contributing observation;
                                            # each header.stamp is that observation's capture time
float32[] tracklet_semantics                # Aggregated semantic embedding [D] accumulated from
                                            # instance embeddings; aggregation method TBD
