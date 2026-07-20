# Frontend-local short-term object hypothesis; not a persistent identity.
uint64 tracklet_id                           # Frontend-local short-term ID; not persistent
meridian_msgs/SegmentRef[] source_segments  # Ordered contributing frame observations
builtin_interfaces/Time first_seen          # Earliest contributing capture time
builtin_interfaces/Time last_seen           # Latest contributing capture time
meridian_msgs/TrackletGeometry geometry     # Geometry evidence and current geometric summary
meridian_msgs/TrackletSemantics semantics   # Per-observation semantic evidence and optional summary
