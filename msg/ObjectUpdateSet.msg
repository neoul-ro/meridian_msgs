# Atomic mutation proposal based on one graph snapshot.
std_msgs/Header header                       # stamp: source TrackletSet frame capture time
uint32 base_graph_version                    # Snapshot version used by Object State Updater
meridian_msgs/ObjectMutation[] mutations     # Proposed atomic graph mutations
