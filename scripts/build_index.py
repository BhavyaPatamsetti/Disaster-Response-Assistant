#!/usr/bin/env python3
"""
Build FAISS vector index for the Disaster Response Assistant.
Processes cleaned text files and creates a searchable vector index.
"""

import os
import sys
import json
import argparse
from pathlib import Path
from typing import List, Dict, Any
import numpy as np
from sentence_transformers import SentenceTransformer
import faiss
import pickle

def chunk_text(text: str, chunk_size: int = 800, overlap: int = 100) -> List[str]:
    """Split text into overlapping chunks"""
    if len(text) <= chunk_size:
        return [text]
    
    chunks = []
    start = 0
    
    while start < len(text):
        end = start + chunk_size
        
        # Try to break at sentence boundaries
        if end < len(text):
            # Look for sentence endings
            for i in range(end, max(start + chunk_size - 200, start), -1):
                if text[i] in '.!?':
                    end = i + 1
                    break
        
        chunk = text[start:end].strip()
        if chunk:
            chunks.append(chunk)
        
        start = end - overlap
        if start >= len(text):
            break
    
    return chunks

def extract_metadata(file_path: Path) -> Dict[str, Any]:
    """Extract metadata from cleaned text file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse header information
    lines = content.split('\n')
    metadata = {
        'filename': file_path.name,
        'source': file_path.stem,
        'total_chars': 0,
        'chunks': []
    }
    
    # Find the content start
    content_start = 0
    for i, line in enumerate(lines):
        if line.startswith('=' * 50):
            content_start = i + 1
            break
    
    if content_start > 0:
        # Extract source info from header
        for line in lines[:content_start]:
            if line.startswith('Source:'):
                metadata['source'] = line.replace('Source:', '').strip()
            elif line.startswith('Extracted:'):
                try:
                    metadata['total_chars'] = int(line.split()[1])
                except (ValueError, IndexError):
                    pass
    
    return metadata

def build_index(input_dir: Path, output_index: Path, output_meta: Path, 
                model_name: str = 'BAAI/bge-small-en-v1.5', 
                chunk_size: int = 800, overlap: int = 100):
    """Build FAISS index from text files"""
    
    print(f"Loading embedding model: {model_name}")
    model = SentenceTransformer(model_name)
    
    # Collect all text files
    text_files = list(input_dir.glob('*.txt'))
    if not text_files:
        print(f"No text files found in {input_dir}")
        sys.exit(1)
    
    print(f"Found {len(text_files)} text files")
    
    # Process files and create chunks
    all_chunks = []
    metadata = []
    
    for file_path in text_files:
        print(f"Processing: {file_path.name}")
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find content start (after header)
        lines = content.split('\n')
        content_start = 0
        for i, line in enumerate(lines):
            if line.startswith('=' * 50):
                content_start = i + 1
                break
        
        if content_start > 0:
            text_content = '\n'.join(lines[content_start:])
        else:
            text_content = content
        
        # Create chunks
        chunks = chunk_text(text_content, chunk_size, overlap)
        
        # Extract file metadata
        file_meta = extract_metadata(file_path)
        
        for i, chunk in enumerate(chunks):
            chunk_meta = {
                'file_id': len(metadata),
                'chunk_id': i,
                'filename': file_path.name,
                'source': file_meta['source'],
                'chunk_size': len(chunk),
                'text': chunk[:200] + "..." if len(chunk) > 200 else chunk  # Preview
            }
            metadata.append(chunk_meta)
            all_chunks.append(chunk)
    
    print(f"Created {len(all_chunks)} chunks")
    
    # Generate embeddings
    print("Generating embeddings...")
    embeddings = model.encode(all_chunks, show_progress_bar=True, normalize_embeddings=True)
    
    # Create FAISS index
    print("Building FAISS index...")
    dimension = embeddings.shape[1]
    
    # Use IndexFlatIP for cosine similarity (since embeddings are normalized)
    index = faiss.IndexFlatIP(dimension)
    index.add(embeddings.astype('float32'))
    
    # Save index
    print(f"Saving index to {output_index}")
    faiss.write_index(index, str(output_index))
    
    # Save metadata
    print(f"Saving metadata to {output_meta}")
    with open(output_meta, 'w', encoding='utf-8') as f:
        json.dump({
            'model_name': model_name,
            'dimension': dimension,
            'total_chunks': len(all_chunks),
            'chunk_size': chunk_size,
            'overlap': overlap,
            'chunks': metadata
        }, f, indent=2, ensure_ascii=False)
    
    print("Index building complete!")
    print(f"  - Total chunks: {len(all_chunks)}")
    print(f"  - Embedding dimension: {dimension}")
    print(f"  - Index size: {os.path.getsize(output_index) / 1024 / 1024:.2f} MB")
    print(f"  - Metadata size: {os.path.getsize(output_meta) / 1024:.2f} KB")

def main():
    parser = argparse.ArgumentParser(description='Build FAISS index from text files')
    parser.add_argument('input_dir', help='Directory containing cleaned text files')
    parser.add_argument('output_index', help='Output path for FAISS index')
    parser.add_argument('output_meta', help='Output path for metadata JSON')
    parser.add_argument('--model', default='BAAI/bge-small-en-v1.5', 
                       help='Sentence transformer model to use')
    parser.add_argument('--chunk-size', type=int, default=800,
                       help='Size of text chunks')
    parser.add_argument('--overlap', type=int, default=100,
                       help='Overlap between chunks')
    
    args = parser.parse_args()
    
    input_dir = Path(args.input_dir)
    output_index = Path(args.output_index)
    output_meta = Path(args.output_meta)
    
    if not input_dir.exists():
        print(f"Error: Input directory {input_dir} does not exist")
        sys.exit(1)
    
    # Create output directory if needed
    output_index.parent.mkdir(parents=True, exist_ok=True)
    output_meta.parent.mkdir(parents=True, exist_ok=True)
    
    build_index(input_dir, output_index, output_meta, 
                args.model, args.chunk_size, args.overlap)

if __name__ == "__main__":
    main()
