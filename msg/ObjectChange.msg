# One committed graph change.
uint8 CREATED=0  # A new object_id was allocated and committed
uint8 UPDATED=1  # An existing object state was committed
uint8 DELETED=2  # An existing object state was deleted

uint8 type                    # CREATED, UPDATED, or DELETED
uint32 object_id              # Stable affected object identity
uint32[] source_tracklet_ids  # Tracklets responsible for this committed change
