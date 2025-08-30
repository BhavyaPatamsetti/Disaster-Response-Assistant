#!/usr/bin/env python3
"""
Convert PDF files to clean text files.
Uses pdfplumber as the primary extractor for better compatibility.
"""

import os
import sys
from pathlib import Path
import pdfplumber
import re

def clean_text(text):
    """Clean and normalize extracted text."""
    if not text:
        return ""
    
    # Remove extra whitespace
    text = re.sub(r'\s+', ' ', text)
    
    # Remove page numbers and headers/footers
    text = re.sub(r'^\s*\d+\s*$', '', text, flags=re.MULTILINE)
    
    # Clean up line breaks
    text = re.sub(r'([.!?])\s*\n', r'\1 ', text)
    text = re.sub(r'\n\s*\n', '\n\n', text)
    
    # Remove excessive spacing
    text = re.sub(r' {2,}', ' ', text)
    
    return text.strip()

def extract_text_from_pdf(pdf_path):
    """Extract text from PDF using pdfplumber."""
    try:
        with pdfplumber.open(pdf_path) as pdf:
            text_parts = []
            for page_num, page in enumerate(pdf.pages, 1):
                page_text = page.extract_text()
                if page_text:
                    text_parts.append(f"Page {page_num}:\n{page_text}")
            
            return "\n\n".join(text_parts)
    except Exception as e:
        print(f"Error extracting text from {pdf_path}: {e}")
        return None

def process_pdfs():
    """Process all PDF files in data/raw/ and save to data/clean/."""
    raw_dir = Path("data/raw")
    clean_dir = Path("data/clean")
    
    # Create directories if they don't exist
    raw_dir.mkdir(exist_ok=True)
    clean_dir.mkdir(exist_ok=True)
    
    # Find all PDF files
    pdf_files = list(raw_dir.glob("*.pdf"))
    
    if not pdf_files:
        print("No PDF files found in data/raw/")
        print("Creating sample text files instead...")
        create_sample_files()
        return
    
    print(f"Found {len(pdf_files)} PDF files to process...")
    
    for pdf_file in pdf_files:
        print(f"Processing {pdf_file.name}...")
        
        # Extract text
        text = extract_text_from_pdf(pdf_file)
        
        if text:
            # Clean text
            cleaned_text = clean_text(text)
            
            # Save to clean directory
            output_file = clean_dir / f"{pdf_file.stem}.txt"
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(cleaned_text)
            
            print(f"  ✓ Saved to {output_file}")
        else:
            print(f"  ✗ Failed to extract text from {pdf_file.name}")
    
    print("PDF processing complete!")

def create_sample_files():
    """Create sample text files for testing."""
    sample_data = {
        "sample_first_aid.txt": """First Aid Basics

Emergency Response Steps:
1. Assess the situation for safety
2. Check if the person is conscious
3. Call emergency services if needed
4. Provide basic first aid until help arrives

Common First Aid Procedures:
- CPR for cardiac arrest
- Heimlich maneuver for choking
- Pressure and elevation for bleeding
- RICE method for sprains and strains

Important Notes:
- Always prioritize your own safety
- Never move someone with suspected spinal injury
- Keep emergency numbers readily available
- Take a first aid course for proper training""",
        
        "sample_survival.txt": """Wilderness Survival Guide

Essential Survival Skills:
1. Finding and purifying water
2. Building shelter from natural materials
3. Starting fires using various methods
4. Identifying edible plants and animals
5. Basic navigation without compass

Water Sources:
- Collect rainwater in containers
- Dig for groundwater in dry riverbeds
- Melt snow and ice
- Collect morning dew on plants

Shelter Building:
- Use natural caves and overhangs
- Build lean-to shelters with branches
- Create debris huts for insulation
- Consider wind direction and drainage

Fire Starting:
- Use friction methods (bow drill, hand drill)
- Create sparks with flint and steel
- Use magnifying glass on sunny days
- Prepare proper tinder and kindling""",
        
        "sample_communications.txt": """Emergency Communication Protocols

Communication Methods:
1. Two-way radio communication
2. Satellite phone for remote areas
3. Emergency beacons and signals
4. Morse code for basic messaging
5. Visual signals and flags

Emergency Signals:
- SOS: ... --- ... (3 short, 3 long, 3 short)
- Help needed: 3 blasts on whistle
- All clear: 1 long blast
- Return to base: 2 short blasts

Radio Etiquette:
- Use clear, concise language
- Identify yourself and location
- Wait for acknowledgment
- Use standard emergency frequencies
- Keep transmissions brief

Visual Communication:
- Signal mirrors for long distance
- Smoke signals for rescue
- Ground-to-air signals
- Flag semaphore for ships
- Hand signals for close range"""
    }
    
    clean_dir = Path("data/clean")
    clean_dir.mkdir(exist_ok=True)
    
    for filename, content in sample_data.items():
        filepath = clean_dir / filename
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Created {filepath}")

if __name__ == "__main__":
    process_pdfs()
