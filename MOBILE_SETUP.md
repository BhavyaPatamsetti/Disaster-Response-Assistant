# 📱 Mobile App Setup Guide

Get your **Flutter Disaster Response Assistant** running on your mobile device!

## 🚨 What You're Building

A **cross-platform mobile app** (iOS/Android) that provides:
- 🏥 **First Aid Guidance** - Immediate emergency response steps
- 🏕️ **Survival Skills** - Water, shelter, fire, food, sanitation
- 📱 **Emergency Communications** - SMS templates and check-in messages
- ✅ **Offline-First Operation** - Works without internet
- 📚 **Source Citations** - Every answer cites specific documents

## 📋 Prerequisites

### Required Software
- **Flutter SDK** (3.10.0 or higher)
- **Python 3.8+** (for backend)
- **Ollama** (for AI model)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Hardware
- **Android device** or **Android emulator**
- **iOS device** or **iOS simulator** (macOS only)
- **Computer** with at least 8GB RAM

## 🚀 Quick Start (5 minutes)

### 1. Install Flutter
```bash
# macOS
brew install flutter

# Windows/Linux
# Visit: https://flutter.dev/docs/get-started/install
```

### 2. Verify Flutter Installation
```bash
flutter doctor
```
Fix any issues reported by `flutter doctor`.

### 3. Setup the Project
```bash
# Clone and setup
git clone <your-repo>
cd disaster-response-assistant

# Run setup script
python setup.py
```

### 4. Start Backend & Mobile App
```bash
# Start both backend and mobile app
python setup.py --start
```

## 📱 Mobile App Features

### 🎨 **Beautiful UI/UX**
- Material Design 3 (Android) + Cupertino (iOS)
- Dark/Light theme support
- Responsive design for all screen sizes
- Smooth animations and transitions

### 🔒 **Offline-First Architecture**
- No internet required after setup
- Local response caching
- Offline indicator always visible
- Works in disaster scenarios

### 🌐 **Multilingual Support**
- English (primary)
- Spanish (Español)
- Hinglish (Hindi + English)
- Easy language switching

### 📱 **Mobile-Specific Features**
- **Emergency SOS Button** - One-tap emergency assistance
- **Location Services** - GPS integration for emergency calls
- **Camera Integration** - Photo documentation of injuries
- **Push Notifications** - Emergency alerts and updates
- **Offline Maps** - Emergency evacuation routes
- **Emergency Contacts** - Quick dial integration

## 🏗️ Project Structure

```
mobile/
├── lib/
│   ├── main.dart              # App entry point
│   ├── providers/             # State management
│   │   └── app_state.dart
│   ├── models/                # Data models
│   │   └── response_data.dart
│   ├── services/              # API services
│   │   └── api_service.dart
│   ├── screens/               # App screens
│   │   ├── home_screen.dart
│   │   ├── first_aid_screen.dart
│   │   ├── survival_screen.dart
│   │   ├── communications_screen.dart
│   │   └── ask_question_screen.dart
│   └── widgets/               # Reusable widgets
│       ├── offline_indicator.dart
│       ├── response_display.dart
│       ├── prompt_button.dart
│       └── settings_drawer.dart
├── android/                   # Android configuration
├── ios/                      # iOS configuration
├── assets/                   # Images, icons, fonts
└── pubspec.yaml             # Flutter dependencies
```

## 🔧 Development Setup

### Android Development
```bash
# Install Android Studio
# Visit: https://developer.android.com/studio

# Setup Android SDK
# Follow Flutter's Android setup guide

# Test on device/emulator
flutter run -d android
```

### iOS Development (macOS only)
```bash
# Install Xcode from App Store
# Install iOS Simulator

# Setup iOS development
flutter run -d ios
```

### Hot Reload Development
```bash
# Start the app
cd mobile
flutter run

# Make changes to code
# App automatically reloads with 'r' key
# Hot restart with 'R' key
```

## 📱 App Navigation

### **Main Tabs**
1. **🏥 First Aid** - Emergency medical guidance
2. **🏕️ Survival** - Wilderness and disaster survival
3. **📱 Communications** - Emergency messaging templates
4. **❓ Ask Question** - Custom emergency questions

### **Quick Actions**
- **Emergency SOS Button** - Floating action button
- **Settings Drawer** - Language, theme, system status
- **Offline Indicator** - Always visible status bar

## 🧪 Testing the App

### **Demo Questions to Try**
1. **First Aid**: "Person has heavy bleeding from forearm—what do I do first?"
2. **Survival**: "How do I make drinking water safe after flooding?"
3. **Communications**: "Generate an SMS check-in message for family"

### **Expected Results**
- ✅ Immediate step-by-step guidance
- ✅ "Do NOT" warnings
- ✅ "When to seek help" advice
- ✅ Source citations with document names
- ✅ Confidence scores
- ✅ Processing time indicators

## 🚀 Production Deployment

### **Android App Bundle**
```bash
cd mobile
flutter build appbundle
# Output: build/app/outputs/bundle/release/app-release.aab
```

### **iOS Archive**
```bash
cd mobile
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode
# Archive and distribute
```

### **App Store Deployment**
- **Google Play Console** for Android
- **App Store Connect** for iOS
- Follow platform-specific guidelines

## 🔧 Troubleshooting

### **Common Issues**

#### "Flutter not found"
```bash
# Add Flutter to PATH
export PATH="$PATH:$HOME/flutter/bin"
# Or restart terminal after installation
```

#### "Android SDK not found"
```bash
# Install Android Studio
# Setup Android SDK
# Run: flutter doctor --android-licenses
```

#### "iOS build failed"
```bash
# Ensure Xcode is installed
# Run: sudo xcode-select --switch /Applications/Xcode.app
# Run: flutter doctor
```

#### "Backend connection failed"
```bash
# Start backend first
python setup.py --backend

# Check if Ollama is running
ollama serve
```

### **Performance Issues**
- **Slow responses**: Check backend performance
- **App crashes**: Check device memory and Flutter version
- **UI lag**: Reduce animation complexity

## 📊 App Analytics

### **Built-in Metrics**
- Response confidence scores
- Processing times
- User interaction patterns
- Offline/online usage statistics

### **Custom Analytics**
```dart
// Add custom tracking
AnalyticsService.trackEvent('question_asked', {
  'category': 'first_aid',
  'language': 'english',
  'confidence': response.confidence,
});
```

## 🔒 Security & Privacy

### **Data Protection**
- No personal data collection
- All responses are anonymous
- Local storage only
- No tracking or analytics

### **Emergency Features**
- SOS button requires confirmation
- Location services are optional
- Camera access is user-controlled
- Emergency contacts are local only

## 🌟 Next Steps

### **Immediate**
1. ✅ Get the app running on your device
2. ✅ Test all three main tabs
3. ✅ Try the emergency SOS button
4. ✅ Test offline functionality

### **Enhancement Ideas**
- **Voice Input**: Speech-to-text for questions
- **Voice Output**: Text-to-speech for responses
- **Offline Maps**: Download emergency maps
- **Emergency Contacts**: Integrate with phone contacts
- **Push Notifications**: Emergency alerts
- **QR Codes**: Share emergency information

### **Customization**
- **Branding**: Custom colors and logos
- **Content**: Add your own emergency procedures
- **Languages**: Add more language support
- **Features**: Custom emergency workflows

---

## 🎯 **Ready to Save Lives?**

Your **Flutter Disaster Response Assistant** is now ready to provide offline-first emergency guidance with source citations!

**Key Benefits:**
- 🚨 **Immediate Access** - No internet required
- 📚 **Vetted Sources** - Every answer is cited
- 🌍 **Multilingual** - Support for multiple languages
- 📱 **Mobile-First** - Optimized for emergency use
- 🔒 **Safe & Reliable** - No hallucinations, only vetted guidance

**Perfect for:**
- Emergency responders
- Disaster preparedness
- Wilderness survival
- First aid training
- Emergency communications

---

**Need help?** Check the main README.md or run `python setup.py --help` for setup assistance.
