# Committed object-layer graph snapshot. Object-object edges are empty in V1.
uint64 graph_version                  # Monotonic committed graph version
string world_frame_id                 # Coordinate frame shared by all world geometry
builtin_interfaces/Time updated_at    # Graph commit time
meridian_msgs/ObjectNode[] nodes      # Object-layer nodes with unique object_id values
