# Proposed state mutation. Local Graph Core allocates IDs and commits it.
uint8 CREATE=0  # Create a new ObjectNode
uint8 UPDATE=1  # Replace one existing ObjectNode state
uint8 DELETE=2  # Delete one existing ObjectNode

uint8 type                              # CREATE, UPDATE, or DELETE
uint64 target_object_id                # 0 for CREATE; existing object_id for UPDATE or DELETE
uint64[] source_tracklet_ids            # Tracklets contributing to this mutation
meridian_msgs/ObjectState proposed_state # Complete post-update state; ignored for DELETE
