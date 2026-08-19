---
name: rag-ai-systems
description: Architecture patterns and implementation standards for Retrieval-Augmented Generation (RAG) and AI agent systems. Use when designing or building document chunking pipelines, embedding generation, vector databases (PGVector, Chroma, Qdrant), hybrid search (BM25 + dense vector), RRF reranking, or LLM context retrieval.
---

# Retrieval-Augmented Generation (RAG) & AI Systems

## When to use this skill
Trigger whenever building, evaluating, or refactoring Retrieval-Augmented Generation (RAG) architectures, vector search integrations, semantic chunking pipelines, hybrid retrieval, or context window budget management.

---

## 1. Core Principles of Production RAG

1. **Garbage In, Garbage Out**: Document parsing and chunking quality dictate 80% of RAG accuracy.
2. **Hybrid Retrieval**: Combine dense semantic search (vector embeddings) with sparse lexical search (BM25/full-text) to handle both conceptual queries and exact keyword/ID lookups.
3. **Strict Context Budgeting**: Track token counts for retrieved chunks and truncate cleanly before exceeding model context limits.
4. **Source Attribution & Grounding**: Every generated answer must cite its retrieved chunk metadata (`source_file`, `page`, `chunk_id`).

---

## 2. RAG Pipeline Architecture

```
[Documents/Vault] ──► [Semantic/Markdown Chunker] ──► [Embedding Model] ──► [Vector Store]
                                                                                   │
[User Query]      ──► [Hybrid Retriever (BM25 + Dense)] ◄──────────────────────────┘
                               │
                      [RRF Reranker / Filter]
                               │
                      [Context Assembler] ──► [LLM Generation with Citations]
```

---

## 3. Production Implementation Patterns

### A. Semantic & Markdown-Aware Chunking
```python
import re
from dataclasses import dataclass

@dataclass
class DocumentChunk:
    chunk_id: str
    content: str
    metadata: dict[str, str | int]

def chunk_markdown(content: str, doc_id: str, max_chunk_tokens: int = 500) -> list[DocumentChunk]:
    """Splits markdown notes on headers while preserving structural context."""
    sections = re.split(r'\n(?=#{1,3}\s)', content)
    chunks: list[DocumentChunk] = []

    for idx, section in enumerate(sections):
        cleaned = section.strip()
        if not cleaned:
            continue
        
        # Extract heading if available
        header_match = re.match(r'^(#{1,3})\s+(.+)', cleaned)
        header = header_match.group(2) if header_match else "General"
        
        chunks.append(DocumentChunk(
            chunk_id=f"{doc_id}_chunk_{idx}",
            content=cleaned,
            metadata={"doc_id": doc_id, "header": header, "length": len(cleaned)}
        ))
    return chunks
```

### B. Reciprocal Rank Fusion (RRF) for Hybrid Search
```python
def reciprocal_rank_fusion(
    vector_results: list[str], 
    bm25_results: list[str], 
    k: int = 60
) -> list[tuple[str, float]]:
    """Combines vector search and BM25 results into a single ranked list."""
    scores: dict[str, float] = {}

    for rank, doc_id in enumerate(vector_results):
        scores[doc_id] = scores.get(doc_id, 0.0) + (1.0 / (k + rank + 1))

    for rank, doc_id in enumerate(bm25_results):
        scores[doc_id] = scores.get(doc_id, 0.0) + (1.0 / (k + rank + 1))

    sorted_docs = sorted(scores.items(), key=lambda item: item[1], reverse=True)
    return sorted_docs
```

### C. Context Assembler with Citations & Token Budgeting
```python
def build_rag_prompt(query: str, retrieved_chunks: list[DocumentChunk], token_limit: int = 2000) -> str:
    context_blocks: list[str] = []
    current_chars = 0
    char_limit = token_limit * 4  # Approximate ~4 chars per token

    for chunk in retrieved_chunks:
        block = f"[Source: {chunk.metadata.get('doc_id', 'unknown')} | Section: {chunk.metadata.get('header', 'N/A')}]\n{chunk.content}\n"
        if current_chars + len(block) > char_limit:
            break
        context_blocks.append(block)
        current_chars += len(block)

    formatted_context = "\n---\n".join(context_blocks)
    
    prompt = f"""You are a reliable AI assistant. Answer the question using ONLY the provided context below.
If the context does not contain the answer, state that you do not know. Always cite sources.

Context:
{formatted_context}

Question: {query}
Answer:"""
    return prompt
```

---

## 4. Unit Testing RAG Pipelines

```python
# tests/test_rag_pipeline.py
import pytest
from src.rag import chunk_markdown, reciprocal_rank_fusion, DocumentChunk

def test_chunk_markdown_preserves_headers():
    doc = "# Intro\nThis is the intro.\n## Features\n- Feature A\n- Feature B"
    chunks = chunk_markdown(doc, doc_id="doc_1")
    
    assert len(chunks) == 2
    assert chunks[0].metadata["header"] == "Intro"
    assert chunks[1].metadata["header"] == "Features"

def test_reciprocal_rank_fusion():
    vec_results = ["doc_a", "doc_b", "doc_c"]
    bm25_results = ["doc_b", "doc_a", "doc_d"]
    
    fused = reciprocal_rank_fusion(vec_results, bm25_results, k=60)
    top_doc = fused[0][0]
    
    # doc_b is rank 1 in BM25 and rank 2 in vector -> should score highest or tie with doc_a
    assert top_doc in ["doc_a", "doc_b"]
```

---

## Things to Avoid

- Avoid naive character-splitting that truncates code blocks or sentences in the middle.
- Avoid passing 50+ raw retrieved chunks directly to an LLM without ranking or deduplication.
- Avoid relying solely on vector embeddings for exact part numbers, UUIDs, or code symbol searches (always pair with BM25).
- Never omit metadata (file path, line number, creation date) from indexed chunks.
