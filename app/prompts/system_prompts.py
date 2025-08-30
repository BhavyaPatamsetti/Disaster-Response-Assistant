"""
System prompts for the Disaster Response Assistant.
These prompts ensure safety, accuracy, and proper citation of sources.
"""

TRIAGE_PROMPT_HEADER = """You are an offline disaster response assistant. Use ONLY the provided sources.
If evidence is insufficient, say: "I don't have vetted guidance for that."

Output sections in order:
1) Immediate steps (numbered, concise)
2) Do NOT (what to avoid)
3) When to seek help
4) Sources (Document Title – Page #)

Never invent facts or medications. If you lack clear sources, say you don't know."""

USER_TEMPLATE = """Question: {user_question}

Context:
{context_chunks}

Please provide guidance based ONLY on the above sources."""

FIRST_AID_PROMPTS = {
    "bleeding": "Person has heavy bleeding from [location]—what do I do first?",
    "cpr": "Someone is unconscious and not breathing—how do I perform CPR?",
    "burns": "Person has [degree] burns on [location]—immediate treatment?",
    "fractures": "Person has a suspected broken [bone]—what should I do?",
    "choking": "Someone is choking and can't speak—how do I help?",
    "shock": "Person shows signs of shock after injury—what do I do?"
}

SURVIVAL_PROMPTS = {
    "water": "How do I make drinking water safe after [disaster]?",
    "shelter": "How do I build emergency shelter in [environment]?",
    "fire": "How do I start a fire safely in [conditions]?",
    "food": "What food is safe to eat in emergency situations?",
    "sanitation": "How do I maintain hygiene without running water?",
    "navigation": "How do I navigate without GPS or compass?"
}

COMMS_PROMPTS = {
    "checkin": "Generate an SMS check-in message for family",
    "emergency": "Create emergency contact message with location",
    "status": "Template for reporting current situation",
    "help": "Message requesting specific assistance",
    "evacuation": "Notification about evacuation plans"
}

MULTILINGUAL_PROMPTS = {
    "spanish": {
        "bleeding": "Persona tiene sangrado abundante en [ubicación]—¿qué hago primero?",
        "water": "¿Cómo hago que el agua sea segura para beber después de [desastre]?",
        "checkin": "Generar mensaje de SMS de verificación para familia"
    },
    "hinglish": {
        "bleeding": "[Location] se heavy bleeding ho raha hai—pehle kya karu?",
        "water": "[Disaster] ke baad drinking water ko safe kaise karu?",
        "checkin": "Family ke liye SMS check-in message generate karo"
    }
}
