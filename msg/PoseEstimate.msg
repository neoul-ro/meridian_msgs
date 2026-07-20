# Camera-to-world pose for one RGBDFrame.
builtin_interfaces/Time timestamp                 # Source RGBDFrame capture time
geometry_msgs/PoseWithCovariance world_t_camera  # Camera pose in the world frame
bool has_covariance                               # Whether world_t_camera.covariance is valid
bool has_trajectory_revision                      # Whether trajectory_revision is valid
uint64 trajectory_revision                        # V2 pose revision; unused in V1
