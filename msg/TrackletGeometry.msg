# Geometry evidence ordered identically to EmbeddedTracklet.source_segments.
sensor_msgs/PointCloud2[] point_clouds_world_m  # [N]; one partial world-frame cloud per observation
geometry_msgs/Point center_world_m              # Current tracklet centroid in the world frame
geometry_msgs/Vector3 extent_world_m            # Current world-axis AABB size, meters
