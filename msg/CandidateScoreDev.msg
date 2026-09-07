# Decomposed score of one candidate node considered by graphcore_node's data
# association for one tracklet (development-stage debug record; element of
# AssociationDecisionDev.candidates). cos / cov_t / cov_n / size_ratio are the
# engine's raw values; sem is cos rescaled with cos_floor; combined is
# w_geom * cov_t + w_sem * sem (no threshold applied).

uint32 object_id      # Candidate node
float32 cos           # Raw cosine between the tracklet embedding and the node summary; NaN when semantics were not used (no embedding on one side, or an embedding-length mismatch - the two are not distinguishable here)
float32 sem           # Rescaled semantic score in [0, 1]; NaN when not used
float32 cov_t         # Share of the tracklet's voxels matched by the node (with grid tolerance); 0 when the intersection was skipped
float32 cov_n         # Share of the node's voxels matched by the tracklet; 0 when skipped
float32 size_ratio    # min(|T|, |N|) / max(|T|, |N|) in voxels
float32 combined      # Combined score; 0 when vetoed or guard_failed
bool vetoed           # cos < veto_cos: dropped before any geometry was computed
bool aabb_skipped     # AABB gate skipped the voxel intersection (cov_t = cov_n = 0)
bool guard_failed     # Size-ratio guard excluded the candidate
