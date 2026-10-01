# Progress report of the meridian pipeline node (package `meridian`), published on
# /meridian/frame_status once per input frame it has finished with, and once more with
# end_of_sequence = true after an end-of-sequence flush.
#
# What it is for: a player can run in lockstep (publish the next frame only after the
# status of the previous one), and an evaluator knows which outputs belong to a frame.
# In lockstep mode ("sync" processing) the status of a frame is sent after the frontend
# has finished the frame AND the data-association thread has finished the ticks that
# frame triggered, so tracklet_ids lists every TrackletDev that frame produced.

std_msgs/Header header             # stamp = capture stamp of the input frame (the last frame for the
                                   # end-of-sequence status); frame_id = world frame of the outputs
uint64 frames_received             # Synchronised input frames (colour + depth + pose) taken so far
uint64 frames_processed            # Of those, frames the frontend actually ran on
uint64 keyframes_published         # Frontend keyframe outputs (TrackletSet) published so far
uint64 tracklets_published         # TrackletDev messages published on /tracklet so far
uint32[] tracklet_ids              # TrackletDev ids published since the previous status
bool end_of_sequence               # true: the end-of-sequence flush is done; nothing follows
