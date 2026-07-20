# Row-major per-observation embeddings with shape [N, embedding_dim].
string embedding_model_id        # Model shared by all stored embeddings
uint32 embedding_dim             # Embedding dimension D
float32[] embeddings             # Row-major [N, D], aligned with source_segments
bool has_embedding_summary       # Whether embedding_summary is valid
float32[] embedding_summary      # Optional aggregate vector [D]; method TBD
