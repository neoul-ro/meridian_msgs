# One aligned RGB-D sensor frame.
builtin_interfaces/Time timestamp  # Capture time and frame key within one sensor stream
sensor_msgs/Image rgb              # Aligned color image; encoding must be rgb8
sensor_msgs/Image depth_m          # Aligned depth image; encoding must be 32FC1 in meters
uint32 calibration_id              # Intrinsics/extrinsics calibration version
