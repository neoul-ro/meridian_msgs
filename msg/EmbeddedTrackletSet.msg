# Complete snapshot of all tracklets in one rolling window.
uint64 window_id                               # Frontend rolling-window ID
builtin_interfaces/Time t_start                # Earliest capture time included in this window
builtin_interfaces/Time t_end                  # Latest capture time included in this window
meridian_msgs/EmbeddedTracklet[] tracklets     # Complete snapshot of tracklets in this window
