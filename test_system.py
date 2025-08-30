#!/usr/bin/env python3
"""
Test script for the Disaster Response Assistant.
Verifies that all components are working correctly.
"""

import sys
import requests
import time
from pathlib import Path

def test_backend_health():
    """Test if the backend is responding"""
    print("🔍 Testing backend health...")
    try:
        response = requests.get("http://localhost:8000/health", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Backend is healthy")
            print(f"   Status: {data['status']}")
            print(f"   Offline: {data['offline']}")
            print(f"   Model loaded: {data['model_loaded']}")
            print(f"   Index loaded: {data['index_loaded']}")
            print(f"   Total chunks: {data.get('total_chunks', 'N/A')}")
            return True
        else:
            print(f"❌ Backend responded with status {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Backend is not running")
        print("   Start it with: python setup.py --backend")
        return False
    except Exception as e:
        print(f"❌ Error testing backend: {e}")
        return False

def test_ollama_connection():
    """Test if Ollama is responding"""
    print("\n🤖 Testing Ollama connection...")
    try:
        response = requests.get("http://localhost:11434/api/tags", timeout=5)
        if response.status_code == 200:
            data = response.json()
            models = data.get('models', [])
            if models:
                print(f"✅ Ollama is running with {len(models)} model(s)")
                for model in models:
                    print(f"   - {model['name']} ({model['size']} bytes)")
                return True
            else:
                print("⚠️  Ollama is running but no models found")
                print("   Pull a model with: ollama pull gpt-oss-1.5-7b")
                return False
        else:
            print(f"❌ Ollama responded with status {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Ollama is not running")
        print("   Start it with: ollama serve")
        return False
    except Exception as e:
        print(f"❌ Error testing Ollama: {e}")
        return False

def test_knowledge_query():
    """Test a simple knowledge query"""
    print("\n📚 Testing knowledge query...")
    try:
        payload = {
            "question": "How do I treat heavy bleeding?",
            "language": "english",
            "top_k": 3,
            "similarity_threshold": 0.35
        }
        
        response = requests.post(
            "http://localhost:8000/ask",
            json=payload,
            timeout=30
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Knowledge query successful")
            print(f"   Answer length: {len(data['answer'])} characters")
            print(f"   Confidence: {data['confidence']:.1%}")
            print(f"   Processing time: {data['processing_time']:.2f}s")
            print(f"   Sources found: {len(data['sources'])}")
            
            # Show first source
            if data['sources']:
                first_source = data['sources'][0]
                print(f"   Top source: {first_source['source']} ({first_source['similarity']:.1%})")
            
            return True
        else:
            print(f"❌ Knowledge query failed with status {response.status_code}")
            print(f"   Error: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error testing knowledge query: {e}")
        return False

def test_prompts_endpoint():
    """Test the prompts endpoint"""
    print("\n💬 Testing prompts endpoint...")
    try:
        response = requests.get("http://localhost:8000/prompts", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print("✅ Prompts endpoint working")
            print(f"   First aid prompts: {len(data.get('first_aid', {}))}")
            print(f"   Survival prompts: {len(data.get('survival', {}))}")
            print(f"   Communication prompts: {len(data.get('communications', {}))}")
            return True
        else:
            print(f"❌ Prompts endpoint failed with status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error testing prompts endpoint: {e}")
        return False

def check_file_structure():
    """Check if all required files and directories exist"""
    print("\n📁 Checking file structure...")
    
    required_paths = [
        "app/backend/main.py",
        "app/ui/main.py",
        "app/prompts/system_prompts.py",
        "scripts/pdf_to_text.py",
        "scripts/build_index.py",
        "data/clean/sample_first_aid.txt",
        "data/clean/sample_survival.txt",
        "data/clean/sample_communications.txt",
        "artifacts/index.faiss",
        "artifacts/meta.json"
    ]
    
    all_exist = True
    for path in required_paths:
        if Path(path).exists():
            print(f"   ✅ {path}")
        else:
            print(f"   ❌ {path}")
            all_exist = False
    
    return all_exist

def main():
    """Run all tests"""
    print("🚨 Disaster Response Assistant - System Test")
    print("=" * 50)
    
    # Check file structure
    if not check_file_structure():
        print("\n❌ File structure check failed")
        print("   Run setup first: python setup.py")
        return False
    
    # Test Ollama
    if not test_ollama_connection():
        print("\n❌ Ollama test failed")
        return False
    
    # Test backend
    if not test_backend_health():
        print("\n❌ Backend test failed")
        return False
    
    # Test prompts endpoint
    if not test_prompts_endpoint():
        print("\n❌ Prompts endpoint test failed")
        return False
    
    # Test knowledge query
    if not test_knowledge_query():
        print("\n❌ Knowledge query test failed")
        return False
    
    print("\n🎉 All tests passed! Your Disaster Response Assistant is working correctly.")
    print("\n🌐 Access your app:")
    print("   Frontend: http://localhost:8501")
    print("   Backend: http://localhost:8000")
    print("   API Docs: http://localhost:8000/docs")
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
