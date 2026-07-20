# Association decisions computed against one committed graph version.
uint64 window_id                                  # Source EmbeddedTrackletSet.window_id
uint64 base_graph_version                         # Graph version used to compute these decisions
meridian_msgs/AssociationDecision[] decisions     # At most one decision per source tracklet
