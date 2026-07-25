# Complete snapshot of all live tracklets in one rolling window.
# Supersedes any previously published TrackletSet.
std_msgs/Header header                      # Source camera frame capture timestamp and frame_id
meridian_msgs/Tracklet[] tracklets          # Full snapshot; consumers must not merge across snapshots
