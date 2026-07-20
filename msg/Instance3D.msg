# One frame-local 3D instance in the world frame.
uint8 segment_id                        # Source SegmentImage pixel value, 1..255
sensor_msgs/PointCloud2 points_world_m  # Object point cloud in the world frame
geometry_msgs/Point center_world_m      # Point-cloud centroid [x, y, z], meters
geometry_msgs/Vector3 extent_world_m    # World-axis AABB size [width, height, depth], meters
float32 geometry_quality                # Algorithm-defined geometry validity score
