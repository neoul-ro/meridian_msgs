# Proposed state mutation. Local Graph Core allocates IDs and commits it.
uint8 CREATE=0
uint8 UPDATE=1

uint8 type
bool has_target_object_id
uint64 target_object_id
uint64[] source_tracklet_ids
meridian_msgs/ObjectState proposed_state
