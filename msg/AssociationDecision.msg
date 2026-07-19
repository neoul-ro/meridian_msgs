# Data Association result for one tracklet.
uint8 MATCH=0
uint8 NEW_OBJECT=1
uint8 DEFER=2

uint64 tracklet_id
uint8 outcome
bool has_matched_object_id
uint64 matched_object_id
bool has_geometry_score
float32 geometry_score
bool has_semantic_score
float32 semantic_score
bool has_combined_score
float32 combined_score
