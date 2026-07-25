# Association decisions computed against one committed graph version.
std_msgs/Header header                            # stamp: source TrackletSet frame capture time
uint32 base_graph_version                         # Graph version used to compute these decisions
meridian_msgs/AssociationDecision[] decisions     # At most one decision per source tracklet
