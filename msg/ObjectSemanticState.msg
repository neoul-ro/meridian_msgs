# Row-major accepted embeddings with shape [N, embedding_dim].
string embedding_model_id        # Model shared by accepted embeddings
uint32 embedding_dim             # Embedding dimension D
float32[] embeddings             # Row-major accepted observation embeddings [N, D]
bool has_embedding_summary       # Whether embedding_summary is valid
float32[] embedding_summary      # Current aggregate vector [D]; method TBD
