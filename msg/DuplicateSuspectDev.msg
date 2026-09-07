# One duplicate-suspect record (recorded, never merged in V1). Element of
# AssociationDecisionDev.duplicate_suspects.
#
# Pair meaning per kind: TWO_NODES_MATCHED = (a = UPDATE target, b = runner-up
# that also cleared the threshold), both existing nodes. NEAR_MISS_CREATE and
# SIZE_GUARD_CREATE = (a = the node just created, score_a = 0 since it was never
# a candidate; b = best candidate, score_b = its combined score - for
# SIZE_GUARD_CREATE the score before the guard zeroed it).

uint8 NEAR_MISS_CREATE=1    # CREATE, but the best score was in [tau_low, tau_match)
uint8 TWO_NODES_MATCHED=2   # UPDATE, and the runner-up also scored >= tau_match
uint8 SIZE_GUARD_CREATE=3   # Best had cov_t >= tau but fell to the size-ratio guard

uint8 kind
uint32 object_id_a
uint32 object_id_b
float32 score_a
float32 score_b
