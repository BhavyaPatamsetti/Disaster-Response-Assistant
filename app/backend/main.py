"""
FastAPI backend for the Disaster Response Assistant.
Provides RAG-based disaster response guidance with source citations.
"""

import os
import json
import time
from typing import List, Dict, Any, Optional
from pathlib import Path
import numpy as np
import faiss
from sentence_transformers import SentenceTransformer
from pydantic import BaseModel
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
import requests

# Import prompts
import sys
sys.path.append(str(Path(__file__).parent.parent))
from prompts.system_prompts import TRIAGE_PROMPT_HEADER, USER_TEMPLATE

app = FastAPI(
    title="Disaster Response Assistant API",
    description="Offline-first disaster response guidance with source citations",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict to specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for loaded models and index
embedding_model = None
faiss_index = None
metadata = None
ollama_client = None

class QueryRequest(BaseModel):
    question: str
    language: str = "english"
    top_k: int = 5
    similarity_threshold: float = 0.35

class QueryResponse(BaseModel):
    answer: str
    sources: List[Dict[str, Any]]
    confidence: float
    processing_time: float
    offline: bool = True

class HealthResponse(BaseModel):
    status: str
    offline: bool
    model_loaded: bool
    index_loaded: bool
    total_chunks: Optional[int] = None
    index_size_mb: Optional[float] = None

def load_models_and_index():
    """Load embedding model, FAISS index, and metadata"""
    global embedding_model, faiss_index, metadata
    
    try:
        # Load embedding model
        print("Loading embedding model...")
        embedding_model = SentenceTransformer('BAAI/bge-small-en-v1.5')
        
        # Load FAISS index
        index_path = Path("artifacts/index.faiss")
        meta_path = Path("artifacts/meta.json")
        
        if not index_path.exists() or not meta_path.exists():
            print("Warning: Index files not found. Run build_index.py first.")
            return False
        
        print("Loading FAISS index...")
        faiss_index = faiss.read_index(str(index_path))
        
        # Load metadata
        print("Loading metadata...")
        with open(meta_path, 'r', encoding='utf-8') as f:
            metadata = json.load(f)
        
        print(f"✓ Models loaded successfully")
        print(f"  - Index: {metadata['total_chunks']} chunks")
        print(f"  - Dimension: {metadata['dimension']}")
        return True
        
    except Exception as e:
        print(f"Error loading models: {e}")
        return False

def query_ollama(prompt: str, model: str = "llama2:7b") -> str:
    """Query Ollama for response generation"""
    try:
        # Check if Ollama is running
        response = requests.get("http://localhost:11434/api/tags", timeout=5)
        if response.status_code != 200:
            raise Exception("Ollama not running")
        
        # Query the model
        payload = {
            "model": model,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.1,  # Low temperature for consistent responses
                "top_p": 0.9,
                "max_tokens": 1000
            }
        }
        
        response = requests.post(
            "http://localhost:11434/api/generate",
            json=payload,
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            return result.get('response', '')
        else:
            raise Exception(f"Ollama API error: {response.status_code}")
            
    except Exception as e:
        print(f"Ollama query failed: {e}")
        return f"Error: Unable to generate response. Please ensure Ollama is running with model {model}."

def retrieve_relevant_chunks(query: str, top_k: int = 5) -> List[Dict[str, Any]]:
    """Retrieve relevant chunks using FAISS similarity search"""
    if embedding_model is None or faiss_index is None:
        raise Exception("Models not loaded")
    
    # Encode query
    query_embedding = embedding_model.encode([query], normalize_embeddings=True)
    
    # Search index
    similarities, indices = faiss_index.search(
        query_embedding.astype('float32'), 
        top_k
    )
    
    # Get chunks and metadata
    results = []
    for i, (similarity, idx) in enumerate(zip(similarities[0], indices[0])):
        if idx < len(metadata['chunks']):
            chunk_info = metadata['chunks'][idx]
            results.append({
                'chunk_id': idx,
                'similarity': float(similarity),
                'text': chunk_info['text'],
                'source': chunk_info['source'],
                'filename': chunk_info['filename']
            })
    
    return results

def generate_response(query: str, chunks: List[Dict[str, Any]], language: str = "english") -> str:
    """Generate response using retrieved chunks and Ollama"""
    
    # Filter chunks by similarity threshold
    relevant_chunks = [c for c in chunks if c['similarity'] >= 0.35]
    
    if not relevant_chunks:
        return "I don't have vetted guidance for that specific question. Please try rephrasing or ask about first aid, survival, or emergency communications."
    
    # Prepare context
    context_text = "\n\n---\n\n".join([
        f"Source: {c['source']} (from {c['filename']})\n{c['text']}"
        for c in relevant_chunks
    ])
    
    # Build prompt
    full_prompt = f"{TRIAGE_PROMPT_HEADER}\n\n{USER_TEMPLATE.format(user_question=query, context_chunks=context_text)}"
    
    # Query Ollama
    response = query_ollama(full_prompt)
    
    # Add source citations if not already present
    if "Sources:" not in response:
        sources_text = "\n\nSources:\n"
        for chunk in relevant_chunks:
            sources_text += f"- {chunk['source']} (from {chunk['filename']})\n"
        response += sources_text
    
    return response

@app.on_event("startup")
async def startup_event():
    """Load models and index on startup"""
    print("Starting Disaster Response Assistant...")
    load_models_and_index()

@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    index_size = None
    if faiss_index is not None:
        index_path = Path("artifacts/index.faiss")
        if index_path.exists():
            index_size = index_path.stat().st_size / (1024 * 1024)
    
    return HealthResponse(
        status="healthy" if (embedding_model and faiss_index) else "unhealthy",
        offline=True,
        model_loaded=embedding_model is not None,
        index_loaded=faiss_index is not None,
        total_chunks=metadata['total_chunks'] if metadata else None,
        index_size_mb=index_size
    )

@app.post("/ask", response_model=QueryResponse)
async def ask_question(request: QueryRequest):
    """Main endpoint for asking disaster response questions"""
    start_time = time.time()
    
    try:
        # Check if models are loaded
        if embedding_model is None or faiss_index is None:
            raise HTTPException(status_code=503, detail="Models not loaded")
        
        # Retrieve relevant chunks
        chunks = retrieve_relevant_chunks(request.question, request.top_k)
        
        if not chunks:
            raise HTTPException(status_code=404, detail="No relevant information found")
        
        # Generate response
        answer = generate_response(request.question, chunks, request.language)
        
        # Calculate confidence based on similarity scores
        avg_similarity = np.mean([c['similarity'] for c in chunks])
        confidence = min(avg_similarity, 1.0)
        
        # Prepare sources for response
        sources = [
            {
                'source': c['source'],
                'filename': c['filename'],
                'similarity': c['similarity'],
                'preview': c['text'][:100] + "..." if len(c['text']) > 100 else c['text']
            }
            for c in chunks
        ]
        
        processing_time = time.time() - start_time
        
        return QueryResponse(
            answer=answer,
            sources=sources,
            confidence=confidence,
            processing_time=processing_time,
            offline=True
        )
        
    except Exception as e:
        processing_time = time.time() - start_time
        raise HTTPException(
            status_code=500, 
            detail=f"Error processing question: {str(e)}"
        )

@app.get("/prompts")
async def get_prompts():
    """Get available prompt templates"""
    from prompts.system_prompts import FIRST_AID_PROMPTS, SURVIVAL_PROMPTS, COMMS_PROMPTS
    
    return {
        "first_aid": FIRST_AID_PROMPTS,
        "survival": SURVIVAL_PROMPTS,
        "communications": COMMS_PROMPTS
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
