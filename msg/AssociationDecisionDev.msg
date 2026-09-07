# Development-stage data-association record for one tracklet, published by
# graphcore_node inside AssociationDecisionSetDev on /association_decision_set
# when debug_decisions is true. Replaces AssociationDecision on that topic
# (the old file stays unchanged). Score fields: cov_t / cov_n / size_ratio / cos
# are the engine's raw values; sem is cos rescaled with cos_floor; score /
# best_score / runner_up_score / candidates[].combined are the weighted
# combination w_geom * cov_t + w_sem * sem (no threshold applied). Every raw
# input a recomputation with other weights needs (cos, cov_t, cov_n, size_ratio)
# is carried. A tracklet without an embedding leaves cos / sem NaN.

# outcome values. Deliberately the reverse of meridian::DecisionType (kCreate = 0,
# kUpdate = 1): msg_adapter converts explicitly, never by static_cast.
uint8 UPDATE=0   # Absorbed into target_object_id
uint8 CREATE=1   # A new node was created

# reject_reason values (why the outcome is CREATE; NONE for UPDATE)
uint8 REJECT_NONE=0
uint8 REJECT_NO_CANDIDATE=1   # Nothing passed the candidate gate
uint8 REJECT_BELOW_TAU=2      # Best surviving candidate scored below its threshold
uint8 REJECT_SEMANTIC_VETO=3  # Every candidate was vetoed on cosine
uint8 REJECT_SIZE_GUARD=4     # Every surviving candidate fell to the size-ratio guard
uint8 REJECT_DIM_MISMATCH=5   # Best candidate's embedding length differs (contract violation)

std_msgs/Header header           # stamp: the tracklet's last_seen (join key with /tracklet and /graph_update_event)
uint64 graph_epoch               # Graph instance the decision was made in
uint64 base_graph_version        # Graph version before this commit
uint32 tracklet_id
uint8 outcome                    # UPDATE or CREATE
uint32 target_object_id          # UPDATE target; 0 for CREATE (the new id is in the commit event)
# best_* / runner_up_*: when reject_reason = REJECT_SIZE_GUARD, best_* is the
# candidate the size-ratio guard excluded, with its combined score before the
# guard zeroed it (its candidates[] row has combined = 0, guard_failed = true),
# and runner_up_* is the best surviving candidate.
uint32 best_object_id            # Best candidate (0 when none); == target_object_id for UPDATE
uint32 runner_up_object_id       # Second candidate (0 when none)
float32 score                    # Combined score of the best candidate (0 when none)
float32 best_score
float32 runner_up_score
float32 cov_t                    # Decomposed score of the best candidate (NaN when none)
float32 cov_n
float32 size_ratio
float32 cos
float32 sem                      # NaN when semantics were not used
bool geometry_only               # Decided on the geometry-only threshold (no embedding to compare)
uint8 reject_reason              # REJECT_* value
uint32 n_candidates              # Candidates that passed the gate, before the per-query cap
meridian_msgs/CandidateScoreDev[] candidates          # Top 8 by combined, descending; best_object_id / runner_up_object_id are always kept in the list
meridian_msgs/DuplicateSuspectDev[] duplicate_suspects  # 0 or 1 record
uint32 latency_us                # Gate -> associate -> commit, microseconds
