# Development-stage association decisions of one commit (graphcore_node,
# debug_decisions = true); one AssociationDecisionDev per tracklet.
std_msgs/Header header                               # stamp: the triggering tracklet's last_seen
uint64 graph_epoch
uint64 base_graph_version                            # Graph version the decisions were computed against
meridian_msgs/AssociationDecisionDev[] decisions
