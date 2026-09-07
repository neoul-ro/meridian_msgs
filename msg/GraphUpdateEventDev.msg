# Development-stage graph change event published on /graph_update_event after
# every commit of graphcore_node, and as a confirmation ("heartbeat") when no
# commit happened for heartbeat_period. Replaces GraphUpdateEvent on that topic.
#
# The payload is a Spark-DSG binary serialisation of a DynamicSceneGraph that
# holds only the nodes changed by this commit (complete node state: voxel keys,
# embedding accumulator, recent-embedding ring, provenance). A consumer applies it
# with DynamicSceneGraph::mergeGraph(delta, {update_dynamic_attributes = true,
# update_archived_attributes = true}); after that its replica equals the server
# node for node. Spark-DSG serialises no deletions, so removed ids travel in
# removed_object_ids (always empty in V1: no DELETE / MERGE yet).
#
# Consumer rules (graph_epoch / graph_version / state_hash): a changed epoch means
# discard the replica and call GetGraph{0, 0}; version == last + 1 means apply and
# compare state_hash; a larger gap or a hash mismatch means GetGraph{epoch, last}.

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
uint32[] changed_object_ids        # Nodes present in graph_blob (V1: exactly one per commit)
uint32[] removed_object_ids        # Nodes deleted by this commit (V1: always empty)
uint8[] graph_blob                 # Spark-DSG binary graph of the changed nodes; empty for a heartbeat
string blob_format                 # Encoding of graph_blob, "spark_dsg_binary"
