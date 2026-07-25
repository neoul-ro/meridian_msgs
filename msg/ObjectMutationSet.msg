# Atomic mutation proposal based on one graph snapshot.
uint64 window_id                             # Source TrackletSet snapshot key; linkage TBD (TrackletSet has no window_id)
uint64 base_graph_version                    # Snapshot version used by Object State Updater
meridian_msgs/ObjectMutation[] mutations     # Proposed atomic graph mutations
