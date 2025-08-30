#!/usr/bin/env python3
"""
Setup script for the Disaster Response Assistant.
This script helps users get started with both the backend and mobile app.
"""

import os
import sys
import subprocess
import platform
from pathlib import Path

def check_python_version():
    """Check if Python version is compatible"""
    if sys.version_info < (3, 8):
        print("❌ Python 3.8 or higher is required")
        print(f"Current version: {sys.version}")
        return False
    print(f"✅ Python {sys.version.split()[0]} detected")
    return True

def check_flutter():
    """Check if Flutter is installed"""
    try:
        result = subprocess.run(['flutter', '--version'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✅ Flutter is installed")
            # Extract Flutter version
            lines = result.stdout.split('\n')
            for line in lines:
                if 'Flutter' in line and 'version' in line:
                    print(f"   {line.strip()}")
                    break
            return True
        else:
            print("❌ Flutter is not working properly")
            return False
    except FileNotFoundError:
        print("❌ Flutter is not installed")
        print("Please install Flutter:")
        print("  Visit: https://flutter.dev/docs/get-started/install")
        return False
    except Exception as e:
        print(f"❌ Error checking Flutter: {e}")
        return False

def check_ollama():
    """Check if Ollama is installed and running"""
    try:
        import requests
        response = requests.get("http://localhost:11434/api/tags", timeout=5)
        if response.status_code == 200:
            print("✅ Ollama is running")
            return True
        else:
            print("⚠️  Ollama is installed but not responding")
            return False
    except:
        print("❌ Ollama is not running")
        print("Please install and start Ollama:")
        if platform.system() == "Darwin":  # macOS
            print("  brew install ollama")
            print("  ollama serve")
        else:
            print("  Visit: https://ollama.ai/download")
        return False

def install_dependencies():
    """Install Python dependencies"""
    print("\n📦 Installing Python dependencies...")
    try:
        subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], 
                      check=True, capture_output=True)
        print("✅ Dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install dependencies: {e}")
        return False

def build_index():
    """Build the FAISS index from sample data"""
    print("\n🔍 Building knowledge index...")
    try:
        # Check if artifacts directory exists
        artifacts_dir = Path("artifacts")
        artifacts_dir.mkdir(exist_ok=True)
        
        # Build index
        result = subprocess.run([
            sys.executable, "scripts/build_index.py",
            "data/clean",
            "artifacts/index.faiss",
            "artifacts/meta.json"
        ], check=True, capture_output=True, text=True)
        
        print("✅ Knowledge index built successfully")
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to build index: {e}")
        print(f"Error output: {e.stderr}")
        return False

def check_models():
    """Check if required models are available"""
    print("\n🤖 Checking AI models...")
    
    # Check embedding model
    try:
        from sentence_transformers import SentenceTransformer
        print("✅ Sentence transformers available")
    except ImportError:
        print("❌ Sentence transformers not available")
        return False
    
    # Check FAISS
    try:
        import faiss
        print("✅ FAISS available")
    except ImportError:
        print("❌ FAISS not available")
        return False
    
    return True

def setup_flutter_app():
    """Setup the Flutter mobile app"""
    print("\n📱 Setting up Flutter mobile app...")
    
    mobile_dir = Path("mobile")
    if not mobile_dir.exists():
        print("❌ Mobile directory not found")
        return False
    
    try:
        # Change to mobile directory
        os.chdir(mobile_dir)
        
        # Get Flutter dependencies
        print("  Getting Flutter dependencies...")
        result = subprocess.run(['flutter', 'pub', 'get'], 
                              check=True, capture_output=True, text=True)
        print("✅ Flutter dependencies installed")
        
        # Check if Android/iOS setup is needed
        print("  Checking platform setup...")
        
        # Check Android
        android_dir = Path("android")
        if android_dir.exists():
            print("✅ Android configuration found")
        
        # Check iOS
        ios_dir = Path("ios")
        if ios_dir.exists():
            print("✅ iOS configuration found")
        
        # Return to original directory
        os.chdir("..")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to setup Flutter app: {e}")
        os.chdir("..")  # Return to original directory
        return False
    except Exception as e:
        print(f"❌ Error setting up Flutter app: {e}")
        os.chdir("..")  # Return to original directory
        return False

def start_backend():
    """Start the FastAPI backend"""
    print("\n🚀 Starting backend server...")
    print("The backend will start on http://localhost:8000")
    print("Press Ctrl+C to stop the server")
    
    try:
        subprocess.run([
            sys.executable, "-m", "uvicorn", "app.backend.main:app", 
            "--reload", "--host", "0.0.0.0", "--port", "8000"
        ])
    except KeyboardInterrupt:
        print("\n✅ Backend server stopped")

def start_frontend():
    """Start the Streamlit frontend"""
    print("\n🎨 Starting Streamlit frontend...")
    print("The frontend will open in your browser")
    print("Press Ctrl+C to stop the server")
    
    try:
        subprocess.run([
            sys.executable, "-m", "streamlit", "run", "app/ui/main.py",
            "--server.port", "8501"
        ])
    except KeyboardInterrupt:
        print("\n✅ Frontend stopped")

def start_mobile():
    """Start the Flutter mobile app"""
    print("\n📱 Starting Flutter mobile app...")
    print("This will launch the app on your connected device or emulator")
    print("Press Ctrl+C to stop the app")
    
    try:
        mobile_dir = Path("mobile")
        os.chdir(mobile_dir)
        
        subprocess.run(['flutter', 'run'])
        
        os.chdir("..")
    except KeyboardInterrupt:
        print("\n✅ Mobile app stopped")
        os.chdir("..")
    except Exception as e:
        print(f"❌ Error starting mobile app: {e}")
        os.chdir("..")

def main():
    """Main setup function"""
    print("🚨 Disaster Response Assistant Setup")
    print("=" * 50)
    
    # Check Python version
    if not check_python_version():
        sys.exit(1)
    
    # Check Flutter
    flutter_available = check_flutter()
    
    # Check models
    if not check_models():
        print("\n❌ Required models not available")
        print("Please install dependencies first:")
        print("  pip install -r requirements.txt")
        sys.exit(1)
    
    # Check Ollama
    ollama_ok = check_ollama()
    
    # Install dependencies if needed
    if not Path("requirements.txt").exists():
        print("❌ requirements.txt not found")
        sys.exit(1)
    
    # Build index
    if not build_index():
        print("\n❌ Failed to build knowledge index")
        sys.exit(1)
    
    # Setup Flutter app if available
    if flutter_available:
        if not setup_flutter_app():
            print("\n⚠️  Flutter app setup had issues, but continuing...")
    
    print("\n✅ Setup completed successfully!")
    print("\nNext steps:")
    print("1. Ensure Ollama is running with a model (e.g., llama2:7b)")
    print("2. Start the backend: python setup.py --backend")
    if flutter_available:
        print("3. Start the mobile app: python setup.py --mobile")
        print("4. Or start both: python setup.py --start")
    else:
        print("3. Start the web frontend: python setup.py --frontend")
        print("4. Or start both: python setup.py --start")
    
    # Handle command line arguments
    if len(sys.argv) > 1:
        if sys.argv[1] == "--backend":
            start_backend()
        elif sys.argv[1] == "--frontend":
            start_frontend()
        elif sys.argv[1] == "--mobile" and flutter_available:
            start_mobile()
        elif sys.argv[1] == "--start":
            print("\n🚀 Starting both backend and frontend...")
            print("Backend: http://localhost:8000")
            if flutter_available:
                print("Mobile: Will launch on device/emulator")
            else:
                print("Frontend: http://localhost:8501")
            
            # Start backend in background
            import threading
            backend_thread = threading.Thread(target=start_backend, daemon=True)
            backend_thread.start()
            
            # Wait a moment for backend to start
            import time
            time.sleep(3)
            
            # Start frontend or mobile
            if flutter_available:
                start_mobile()
            else:
                start_frontend()

if __name__ == "__main__":
    main()
