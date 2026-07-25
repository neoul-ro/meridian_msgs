# All valid positive segments reconstructed for one frame.
# segment_ids and instance_points are parallel arrays:
# segment_ids[k] labels instance_points[k]; sizes must match.
std_msgs/Header header                            # Source camera frame capture timestamp and frame_id
uint8[] segment_ids                               # [N]; /segment_image pixel value (1..255) per cloud
sensor_msgs/PointCloud2[] instance_points         # [N]; world-frame cloud per instance, point counts may differ
