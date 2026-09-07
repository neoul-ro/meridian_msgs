# Development-stage graph change event published on /graph_update_event after
# every commit of graphcore_node, and as a confirmation ("heartbeat") when no
# commit happened for heartbeat_period. Replaces GraphUpdateEvent on that topic.
#
# The payload is a Spark-DSG binary serialisation of a DynamicSceneGraph that
# holds only the nodes changed by this commit (complete node state: voxel keys,
# embedding accumulator, recent-embedding ring, provenance). A consumer applies it
# with DynamicSceneGraph::mergeGraph(delta, {update_dynamic_attributes = true,
# update_archived_attributes = true}); after that its replica equals the server
# node for node. Spark-DSG serialises no deletions, so ids that left the graph
# travel outside the blob, in removed_object_ids and merged_from (see there).
#
# Consumer rules (graph_epoch / graph_version / state_hash): a changed epoch means
# discard the replica and call GetGraph{0, 0}; version == last + 1 + len(merged_from)
# means apply the blob, delete the merged_from nodes and compare state_hash; a larger
# gap or a hash mismatch means GetGraph{epoch, last}. A merge is a commit of its own,
# so a commit that also merged steps graph_version by one more than usual - the
# merged_from array says by how much.

std_msgs/Header header             # stamp: last_seen of the triggering tracklet (join key with
                                   # /tracklet and /association_decision_set); the publish time
                                   # for a heartbeat. frame_id: world frame of every position
uint64 graph_epoch                 # Identity of this graph instance; changes on restart or load
uint64 graph_version               # Version after this commit (+1 per commit); unchanged for a heartbeat
builtin_interfaces/Time updated_at # Wall-clock publish time
float32 voxel_size                 # Store grid (metres); every node's voxel keys use it
string embedding_model_id          # Store embedding model; empty while no embedded tracklet arrived
uint16 embedding_dim               # Store embedding dimension
uint64 state_hash                  # FNV-1a over the published summary fields of every node at graph_version
bool is_heartbeat                  # true: confirmation only, graph_blob empty, no ids
uint32 tracklet_id                 # The tracklet whose commit produced this event; 0 for a heartbeat.
                                   # Read this instead of the last entry of the changed node's
                                   # source_tracklet_ids: that ring keeps the newest entries of both
                                   # nodes after a merge, so its last entry can belong to the
                                   # absorbed node when the two share a stamp
uint32[] changed_object_ids        # Nodes present in graph_blob (exactly one per commit)
# The two ways a node can leave the graph; they never overlap, and a consumer
# deletes the ids of both from its replica.
uint32[] removed_object_ids        # Nodes deleted by this commit with no successor (still always empty: nothing is deleted outright)
uint32[] merged_from               # Nodes deleted because they were merged into another node
uint32[] merged_into               # Parallel to merged_from: the node that absorbed merged_from[i]; its new state is in graph_blob
uint8[] graph_blob                 # Spark-DSG binary graph of the changed nodes; empty for a heartbeat
string blob_format                 # Encoding of graph_blob, "spark_dsg_binary"
