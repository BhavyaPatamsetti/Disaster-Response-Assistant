"""
Streamlit UI for the Disaster Response Assistant.
Provides an intuitive interface for disaster response guidance.
"""

import streamlit as st
import requests
import json
import time
from typing import Dict, Any
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent))
from prompts.system_prompts import FIRST_AID_PROMPTS, SURVIVAL_PROMPTS, COMMS_PROMPTS, MULTILINGUAL_PROMPTS

# Page configuration
st.set_page_config(
    page_title="Disaster Response Assistant",
    page_icon="🚨",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for better styling
st.markdown("""
<style>
    .main-header {
        background: linear-gradient(90deg, #ff6b6b, #ee5a24);
        padding: 1rem;
        border-radius: 10px;
        color: white;
        text-align: center;
        margin-bottom: 2rem;
    }
    .offline-indicator {
        background: #00b894;
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        text-align: center;
        font-weight: bold;
        margin-bottom: 1rem;
    }
    .category-button {
        background: #74b9ff;
        color: white;
        padding: 1rem;
        border-radius: 10px;
        text-align: center;
        margin: 0.5rem 0;
        cursor: pointer;
        transition: all 0.3s;
    }
    .category-button:hover {
        background: #0984e3;
        transform: translateY(-2px);
    }
    .response-box {
        background: #f8f9fa;
        padding: 1.5rem;
        border-radius: 10px;
        border-left: 5px solid #74b9ff;
        margin: 1rem 0;
    }
    .sources-box {
        background: #e8f4fd;
        padding: 1rem;
        border-radius: 8px;
        margin-top: 1rem;
    }
    .confidence-bar {
        background: #ddd;
        height: 8px;
        border-radius: 4px;
        overflow: hidden;
        margin: 0.5rem 0;
    }
    .confidence-fill {
        height: 100%;
        background: linear-gradient(90deg, #ff6b6b, #00b894);
        transition: width 0.3s;
    }
</style>
""", unsafe_allow_html=True)

# Initialize session state
if 'current_response' not in st.session_state:
    st.session_state.current_response = None
if 'current_sources' not in st.session_state:
    st.session_state.current_sources = None
if 'processing' not in st.session_state:
    st.session_state.processing = False

# Configuration
BACKEND_URL = "http://localhost:8000"
DEFAULT_LANGUAGE = "english"

def check_backend_health():
    """Check if backend is running and healthy"""
    try:
        response = requests.get(f"{BACKEND_URL}/health", timeout=5)
        if response.status_code == 200:
            return response.json()
        return None
    except:
        return None

def query_backend(question: str, language: str = "english") -> Dict[str, Any]:
    """Query the backend API"""
    try:
        payload = {
            "question": question,
            "language": language,
            "top_k": 5,
            "similarity_threshold": 0.35
        }
        
        response = requests.post(
            f"{BACKEND_URL}/ask",
            json=payload,
            timeout=30
        )
        
        if response.status_code == 200:
            return response.json()
        else:
            st.error(f"Backend error: {response.status_code}")
            return None
            
    except Exception as e:
        st.error(f"Connection error: {str(e)}")
        return None

def display_response(response_data: Dict[str, Any]):
    """Display the response in a formatted way"""
    if not response_data:
        return
    
    # Main response
    st.markdown("### 📋 Response")
    st.markdown(response_data['answer'])
    
    # Confidence indicator
    confidence = response_data.get('confidence', 0)
    st.markdown(f"**Confidence:** {confidence:.1%}")
    
    # Confidence bar
    st.markdown("""
    <div class="confidence-bar">
        <div class="confidence-fill" style="width: {}%"></div>
    </div>
    """.format(confidence * 100), unsafe_allow_html=True)
    
    # Processing time
    processing_time = response_data.get('processing_time', 0)
    st.caption(f"Processed in {processing_time:.2f} seconds")
    
    # Sources
    if response_data.get('sources'):
        st.markdown("### 📚 Sources")
        sources = response_data['sources']
        
        for i, source in enumerate(sources):
            with st.expander(f"Source {i+1}: {source['source']} ({source['filename']})"):
                st.markdown(f"**Similarity:** {source['similarity']:.1%}")
                st.markdown(f"**Preview:** {source['preview']}")

def main():
    # Header
    st.markdown("""
    <div class="main-header">
        <h1>🚨 Disaster Response Assistant</h1>
        <p>Offline-first emergency guidance with source citations</p>
    </div>
    """, unsafe_allow_html=True)
    
    # Offline indicator
    health_data = check_backend_health()
    if health_data and health_data.get('status') == 'healthy':
        st.markdown("""
        <div class="offline-indicator">
            ✅ Offline Mode Active - All systems operational
        </div>
        """, unsafe_allow_html=True)
        
        # Show system status
        col1, col2, col3 = st.columns(3)
        with col1:
            st.metric("Index Chunks", health_data.get('total_chunks', 'N/A'))
        with col2:
            st.metric("Index Size", f"{health_data.get('index_size_mb', 0):.1f} MB")
        with col3:
            st.metric("Status", health_data.get('status', 'Unknown'))
    else:
        st.error("⚠️ Backend not available. Please ensure the FastAPI server is running.")
        st.info("Start the backend with: `cd app/backend && uvicorn main:app --reload`")
        return
    
    # Language selection
    language = st.sidebar.selectbox(
        "🌐 Language",
        ["english", "spanish", "hinglish"],
        index=0
    )
    
    # Main tabs
    tab1, tab2, tab3, tab4 = st.tabs(["🏥 First Aid", "🏕️ Survival", "📱 Communications", "❓ Ask Question"])
    
    with tab1:
        st.markdown("### 🏥 First Aid Guidance")
        st.markdown("Select a first aid scenario or ask a specific question:")
        
        # Quick prompts
        col1, col2 = st.columns(2)
        with col1:
            for key, prompt in list(FIRST_AID_PROMPTS.items())[:3]:
                if st.button(f"🔴 {key.title()}", key=f"fa1_{key}"):
                    st.session_state.processing = True
                    response = query_backend(prompt, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
        
        with col2:
            for key, prompt in list(FIRST_AID_PROMPTS.items())[3:]:
                if st.button(f"🔴 {key.title()}", key=f"fa2_{key}"):
                    st.session_state.processing = True
                    response = query_backend(prompt, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
        
        # Custom question
        custom_question = st.text_input("Or ask a custom first aid question:", key="fa_custom")
        if st.button("Get Guidance", key="fa_search"):
            if custom_question:
                st.session_state.processing = True
                response = query_backend(custom_question, language)
                if response:
                    st.session_state.current_response = response
                    st.session_state.current_sources = response.get('sources', [])
                st.session_state.processing = False
                st.rerun()
    
    with tab2:
        st.markdown("### 🏕️ Survival Skills")
        st.markdown("Learn essential survival techniques for emergency situations:")
        
        # Quick prompts
        col1, col2 = st.columns(2)
        with col1:
            for key, prompt in list(SURVIVAL_PROMPTS.items())[:3]:
                if st.button(f"🌿 {key.title()}", key=f"surv1_{key}"):
                    st.session_state.processing = True
                    response = query_backend(prompt, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
        
        with col2:
            for key, prompt in list(SURVIVAL_PROMPTS.items())[3:]:
                if st.button(f"🌿 {key.title()}", key=f"surv2_{key}"):
                    st.session_state.processing = True
                    response = query_backend(prompt, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
        
        # Custom question
        custom_question = st.text_input("Or ask a custom survival question:", key="surv_custom")
        if st.button("Get Guidance", key="surv_search"):
            if custom_question:
                st.session_state.processing = True
                response = query_backend(custom_question, language)
                if response:
                    st.session_state.current_response = response
                    st.session_state.current_sources = response.get('sources', [])
                st.session_state.processing = False
                st.rerun()
    
    with tab3:
        st.markdown("### 📱 Emergency Communications")
        st.markdown("Generate emergency communication templates:")
        
        # Quick prompts
        col1, col2 = st.columns(2)
        with col1:
            for key, prompt in list(COMMS_PROMPTS.items())[:3]:
                if st.button(f"📱 {key.title()}", key=f"comms1_{key}"):
                    st.session_state.processing = True
                    response = query_backend(prompt, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
        
        with col2:
            for key, prompt in list(COMMS_PROMPTS.items())[3:]:
                if st.button(f"📱 {key.title()}", key=f"comms2_{key}"):
                    st.session_state.processing = True
                    response = query_backend(prompt, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
        
        # Custom question
        custom_question = st.text_input("Or ask a custom communications question:", key="comms_custom")
        if st.button("Get Guidance", key="comms_search"):
            if custom_question:
                st.session_state.processing = True
                response = query_backend(custom_question, language)
                if response:
                    st.session_state.current_response = response
                    st.session_state.current_sources = response.get('sources', [])
                st.session_state.processing = False
                st.rerun()
    
    with tab4:
        st.markdown("### ❓ Ask Any Question")
        st.markdown("Ask any disaster response or emergency preparedness question:")
        
        # Question input
        question = st.text_area(
            "What would you like to know about disaster response?",
            height=100,
            placeholder="e.g., How do I treat a deep cut? What should I pack in an emergency kit?"
        )
        
        col1, col2 = st.columns([1, 3])
        with col1:
            if st.button("🔍 Get Answer", type="primary"):
                if question.strip():
                    st.session_state.processing = True
                    response = query_backend(question, language)
                    if response:
                        st.session_state.current_response = response
                        st.session_state.current_sources = response.get('sources', [])
                    st.session_state.processing = False
                    st.rerun()
                else:
                    st.warning("Please enter a question.")
        
        with col2:
            if question.strip():
                st.info("💡 Tip: Be specific about the emergency situation for better guidance.")
    
    # Display current response if available
    if st.session_state.current_response:
        st.markdown("---")
        display_response(st.session_state.current_response)
        
        # Copy button for response
        if st.button("📋 Copy Response"):
            st.write("Response copied to clipboard!")
            st.code(st.session_state.current_response['answer'])
    
    # Processing indicator
    if st.session_state.processing:
        with st.spinner("🔍 Searching knowledge base and generating response..."):
            time.sleep(0.1)  # Small delay for UI feedback

if __name__ == "__main__":
    main()
