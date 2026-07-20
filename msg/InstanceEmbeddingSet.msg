# Row-major embedding matrix with one row per segment_ids entry.
builtin_interfaces/Time timestamp  # Source RGBDFrame capture time
string embedding_model_id         # Model, weights, and preprocessing configuration ID
uint8[] segment_ids                # [N]; segment_ids[n] owns embedding row n
uint32 embedding_dim               # Embedding dimension D
float32[] embeddings               # Row-major flattened matrix [N, D]
