# One node-node merge verification (development-stage record; element of
# AssociationDecisionDev.merge_verifications, 0 or 1 per commit).
#
# A duplicate-suspect signal only proposes a pair; before graphcore_node may
# merge it, the DA engine compares the two nodes directly
# (DaEngine::verifyMerge). This message is that comparison: which signal
# proposed the pair, the measured values, whether they passed, and whether the
# graph really merged them. It is written whether or not merging is enabled -
# with enable_merge false (the default) nothing is merged and applied is always
# false, which is the mode the merge thresholds are measured in.
#
# The pair is ordered: object_id_a < object_id_b, and cov_ab belongs to
# object_id_a. That makes the record independent of the order the signal named
# the two nodes in. On an applied merge the smaller id survives
# (kept_object_id == object_id_a) and the larger one is gone from the graph.
# Score fields are raw values, no threshold applied: cov_* and size_ratio are
# the level-aligned geometry, cos is the raw cosine of the two accumulated
# embeddings, sem is cos rescaled with cos_floor, and score is
# w_geom * min(cov_ab, cov_ba) + w_sem * sem (min(cov_ab, cov_ba) alone when
# geometry_only). A pair with no comparable embedding leaves cos / sem NaN.

# signal values: the duplicate-suspect kind that proposed this pair
# (same values as DuplicateSuspectDev)
uint8 NEAR_MISS_CREATE=1
uint8 TWO_NODES_MATCHED=2
uint8 SIZE_GUARD_CREATE=3

# reject_reason values: the first threshold the pair failed (NONE when confirmed)
uint8 REJECT_NONE=0
uint8 REJECT_SAME_NODE=1       # Both ids equal: nothing to merge (never expected)
uint8 REJECT_EMPTY_GEOMETRY=2  # One node has no voxel: no containment to measure
uint8 REJECT_COVERAGE=3        # min(cov_ab, cov_ba) below merge_cov_min
uint8 REJECT_SIZE_RATIO=4      # size_ratio below merge_size_ratio_min
uint8 REJECT_SEMANTIC=5        # Comparable pair with cos below merge_cos_min
uint8 REJECT_SCORE=6           # score below tau_merge (tau_merge_geom_only when geometry_only)
uint8 REJECT_DIM_MISMATCH=7    # Both nodes carry an embedding but of different lengths (store
                               # contract violation): refused outright, never decided on geometry

uint8 signal                 # NEAR_MISS_CREATE, TWO_NODES_MATCHED or SIZE_GUARD_CREATE
uint32 object_id_a           # The pair, object_id_a < object_id_b
uint32 object_id_b
float32 cov_ab               # Share of a's voxels covered by b (grid-aligned, tol_voxels slack)
float32 cov_ba               # Share of b's voxels covered by a
float32 size_ratio           # min(|A|, |B|) / max(|A|, |B|) in aligned voxels
float32 cos                  # Raw cosine of the two emb_sum vectors; NaN when not comparable
float32 sem                  # cos rescaled with cos_floor; NaN when not comparable
float32 score                # Combined confirmation score (see above)
bool geometry_only           # No comparable embedding: decided against tau_merge_geom_only
bool confirmed               # Every threshold passed
uint8 reject_reason          # REJECT_* value
bool applied                 # The graph merged the pair (confirmed and enable_merge)
uint32 kept_object_id        # Surviving node; 0 when nothing was applied
uint32 absorbed_object_id    # Node that is gone; 0 when nothing was applied
