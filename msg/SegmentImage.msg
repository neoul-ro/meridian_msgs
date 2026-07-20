# Pixel-wise frame-local instance labels.
builtin_interfaces/Time timestamp  # Source RGBDFrame capture time
sensor_msgs/Image labels           # mono8 [H, W]; pixel value is frame-local segment_id
