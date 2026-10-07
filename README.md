# Disaster Response Assistant — Fork

A fork containing a retrieval-augmented assistant with FastAPI, Streamlit, a FAISS knowledge index, local Ollama generation, and a Flutter mobile client.

## What is included

- Backend: `app/backend/main.py`.
- Web UI: `app/ui/main.py`.
- Index construction: `scripts/build_index.py`.
- Mobile client: `mobile/`.
- Existing setup guides: `QUICKSTART.md` and `MOBILE_SETUP.md`.

## Getting started

Install the Python requirements in an isolated environment, install/run Ollama, and obtain the model expected by the backend (`llama2:7b`). From the repository root:

```sh
pip install -r requirements.txt
python scripts/build_index.py data/clean/ artifacts/index.faiss artifacts/meta.json
python -m uvicorn app.backend.main:app --reload --port 8000
```

In another terminal, from the same root:

```sh
streamlit run app/ui/main.py
```

Keeping the root as the working directory lets relative `artifacts/` paths resolve.

## Repository guide

- `Dockerfile.backend`
- `MOBILE_SETUP.md`
- `QUICKSTART.md`
- `README.md`
- `app/`
- `create-portable.sh`
- `data/`
- `docker-compose.yml`
- `ios/`
- `mobile/`
- `models/`
- `pubspec.yaml`
- `requirements.txt`
- `scripts/`
- `setup.py`
- `start-docker.sh`
- `test_system.py`

## Limitations and reproducibility

This repository is marked as a fork; preserve upstream attribution and do not present all code as original work. Model/index downloads are required before offline use. The backend hard-codes a localhost Ollama URL, which needs adjustment for container networking. Generated emergency guidance is not a substitute for trained responders or verified emergency instructions.

## Original upstream documentation

The original documentation is retained below to preserve project context and attribution. Some original setup claims need the qualifications above.

# Disaster Response Assistant

An **offline-first** disaster response assistant that provides first-aid, survival, and communications guidance during emergencies without requiring internet connectivity.

**Available as:**
- 📱 **Flutter Mobile App** (iOS/Android)
- 🌐 **Web Interface** (Streamlit)
- 🔧 **Backend API** (FastAPI)

## 🎯 Goal & Guardrails

- **Goal:** Offline assistant that gives **first-aid, survival, and comms guidance** during disasters
- **Non-negotiables:**
  1. Runs with **no internet** (Ollama or vLLM)
  2. **Cites** the local source for every answer
  3. **Refuses** to answer outside its curated knowledge
  4. Shows an **offline indicator** in UI

## 🏗️ Architecture

- **Mobile App**: Flutter (iOS/Android)
- **Backend**: FastAPI with RAG capabilities
- **Runtime**: Ollama (simplest) or vLLM
- **Reasoning Model**: GPT-OSS instruct model (runs on laptop/server)
- **Embeddings**: BGE-small or GTE-small via sentence-transformers
- **Vector DB**: FAISS (in-process, no services)
- **Speech (optional)**: Whisper.cpp (STT) + Piper (TTS)

## 🚀 Features

### Three Core Tabs
1. **First Aid** - Bleeding, CPR, burns, fractures
2. **Survival** - Water, shelter, fire, food, sanitation
3. **Comms** - Offline SMS templates, check-in messages, location notes

### Safety Features
- **No hallucinations:** Only uses vetted sources
- **Explicit citations:** Document title + page number
- **Risk disclaimers:** "When to seek help" guidance
- **Refusal paths:** "I don't have vetted guidance for that"

## 📁 Project Structure

```
disaster-assistant/
├── mobile/               # Flutter mobile app
│   ├── lib/             # Dart source code
│   ├── android/         # Android configuration
│   ├── ios/             # iOS configuration
│   └── pubspec.yaml     # Flutter dependencies
├── web/                 # Streamlit web interface
├── app/
│   ├── backend/         # FastAPI server
│   └── prompts/         # System prompts
├── data/
│   ├── raw/             # PDFs you ship
│   └── clean/           # Generated txt/md
├── artifacts/
│   ├── index.faiss      # Vector index
│   └── meta.json        # Metadata
├── scripts/
│   ├── pdf_to_text.py   # PDF conversion
│   ├── build_index.py   # Index building
│   └── eval_retrieval.py # Quality testing
└── models/               # Local weights notes
```

## 🛠️ Quick Start

### Prerequisites
```bash
# Install Ollama
brew install ollama  # macOS
# or use official installer for other platforms

# Install Flutter
# Visit: https://flutter.dev/docs/get-started/install

# Python environment
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

### Setup
```bash
# 1. Pull model
ollama pull gpt-oss-1.5-7b  # or your preferred model

# 2. Prepare data
python scripts/pdf_to_text.py data/raw/ data/clean/
python scripts/build_index.py data/clean/ artifacts/index.faiss artifacts/meta.json

# 3. Run backend
cd app/backend && uvicorn main:app --reload

# 4. Run mobile app
cd mobile && flutter run
```

## 📱 Mobile App Features

### Flutter Implementation
- **Cross-platform**: iOS and Android support
- **Offline-first**: Works without internet connection
- **Native UI**: Material Design (Android) and Cupertino (iOS)
- **Responsive**: Adapts to different screen sizes
- **Dark/Light mode**: Automatic theme switching
- **Local storage**: Caches responses for offline access

### Mobile-Specific Features
- **Push notifications**: Emergency alerts
- **Location services**: GPS integration for emergency calls
- **Camera integration**: Photo documentation of injuries
- **Offline maps**: Emergency evacuation routes
- **Emergency contacts**: Quick dial integration
- **SOS button**: One-tap emergency assistance

## 🔒 Safety Layer

- **Triage prompt header** always prepended
- **Banned outputs:** No diagnosis, no drug dosages unless explicitly in sources
- **Output format:** Immediate steps, Why, Do NOT, When to seek help, Sources

## 📊 Quality Gates

- **Retrieval coverage:** 20 gold questions → ensure 2+ relevant chunks per answer
- **Hallucination test:** Must refuse out-of-scope medical questions
- **Latency:** Target <2.5s on CPU for short answers
- **Power loss:** App should restart and load index in <5s

## 🎬 Demo Script (≤3 minutes)

1. **Show no internet** (Wi-Fi off)
2. Open mobile app → **Offline ✅** visible
3. Ask: "Person has heavy bleeding from forearm—what do I do first?"
   - See steps, Do NOT, Seek help, Sources
4. Switch to **Survival**: "Make drinking water safe after flooding"
5. **Comms tab**: auto-generated **SMS check-in template** (copy button)
6. Bonus: same query in Spanish → shows localized steps

## 📝 License

MIT License

## 🤝 Contributing

This project focuses on **safety and reliability**. All contributions must maintain the offline-first, source-cited approach.

# Disaster-Response-Assistant
