# 🚀 Quick Start Guide

Get your Disaster Response Assistant running in under 5 minutes!

## Prerequisites

- **Python 3.8+** installed
- **Ollama** installed and running
- **Internet connection** (only for initial setup)

## 🚨 Step-by-Step Setup

### 1. Install Ollama (if not already installed)

```bash
# macOS
brew install ollama

# Linux/Windows
# Visit: https://ollama.ai/download
```

### 2. Start Ollama and pull a model

```bash
# Start Ollama service
ollama serve

# In another terminal, pull a model
ollama pull gpt-oss-1.5-7b
# or any other model you prefer
```

### 3. Install Python dependencies

```bash
# Create virtual environment (recommended)
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 4. Run the setup script

```bash
python setup.py
```

This will:
- ✅ Check your Python version
- ✅ Verify dependencies
- ✅ Build the knowledge index from sample data
- ✅ Check if Ollama is running

### 5. Start the application

```bash
# Option 1: Start both backend and frontend
python setup.py --start

# Option 2: Start separately
# Terminal 1: Backend
python setup.py --backend

# Terminal 2: Frontend  
python setup.py --frontend
```

## 🌐 Access Your App

- **Frontend**: http://localhost:8501
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

## 🧪 Test It Out

1. **First Aid Tab**: Click "Bleeding" → Get immediate guidance
2. **Survival Tab**: Click "Water" → Learn water purification
3. **Communications Tab**: Click "Checkin" → Get SMS templates
4. **Ask Question**: Type "How do I treat a burn?" → Get detailed response

## 📚 Add Your Own Knowledge

1. **Place PDFs** in `data/raw/` directory
2. **Convert to text**: `python scripts/pdf_to_text.py data/raw/ data/clean/`
3. **Rebuild index**: `python scripts/build_index.py data/clean/ artifacts/index.faiss artifacts/meta.json`
4. **Restart backend** to load new index

## 🔧 Troubleshooting

### "Ollama not running"
```bash
ollama serve
```

### "Models not loaded"
```bash
pip install -r requirements.txt
```

### "Index files not found"
```bash
python setup.py  # This will rebuild the index
```

### "Backend not available"
```bash
python setup.py --backend
```

## 🎯 Demo Script (3 minutes)

1. **Show offline mode** ✅ (no internet ping)
2. **Ask**: "Person has heavy bleeding from forearm—what do I do first?"
3. **Show response** with steps, Do NOT, Seek help, Sources
4. **Switch to Survival**: "Make drinking water safe after flooding"
5. **Communications tab**: Generate SMS check-in template
6. **Bonus**: Same query in Spanish/Hinglish

## 🚀 Production Deployment

For production use:
- Use `gunicorn` instead of `uvicorn`
- Set up proper CORS origins
- Use environment variables for configuration
- Consider using a proper database for metadata
- Implement user authentication if needed

## 📞 Support

- Check the main README.md for detailed documentation
- Review the API documentation at `/docs` endpoint
- Check logs in the terminal for error messages

---

**Ready to save lives?** 🚨 Your Disaster Response Assistant is now running offline-first with source citations!
