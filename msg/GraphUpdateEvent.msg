# Changes committed for one source window.
uint64 graph_version                    # Graph version produced by this commit
uint64 source_window_id                 # EmbeddedTrackletSet window that triggered the commit
builtin_interfaces/Time updated_at      # Graph commit time
meridian_msgs/ObjectChange[] changes    # Committed object changes
