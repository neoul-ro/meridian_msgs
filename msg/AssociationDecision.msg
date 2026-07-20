# Data Association result for one tracklet.
uint8 MATCH=0       # Associate with matched_object_id
uint8 NEW_OBJECT=1  # Request a new persistent object
uint8 DEFER=2       # Produce no graph mutation for this tracklet

uint64 tracklet_id              # EmbeddedTracklet ID within the source window
uint8 outcome                   # MATCH, NEW_OBJECT, or DEFER
bool has_matched_object_id      # Whether matched_object_id is valid
uint64 matched_object_id        # Existing stable object_id selected by DA
bool has_geometry_score         # Whether geometry_score is valid
float32 geometry_score          # Algorithm-defined geometric evidence
bool has_semantic_score         # Whether semantic_score is valid
float32 semantic_score          # Algorithm-defined semantic evidence
bool has_combined_score         # Whether combined_score is valid
float32 combined_score          # Algorithm-defined final association score
