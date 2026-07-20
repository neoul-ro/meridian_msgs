# Complete persistent state without a stable object ID.
meridian_msgs/SegmentRef[] source_segments  # Unique observation keys already incorporated
builtin_interfaces/Time first_seen          # Earliest incorporated capture time
builtin_interfaces/Time last_seen           # Latest incorporated capture time
meridian_msgs/ObjectGeometryState geometry  # Persistent geometry used by later DA
meridian_msgs/ObjectSemanticState semantics # Persistent semantic evidence used by later DA
