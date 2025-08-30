import 'package:flutter/material.dart';
import 'package:disaster_response_assistant/services/api_service.dart';
import 'package:disaster_response_assistant/models/response_data.dart';

class AppState extends ChangeNotifier {
  // Theme
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Language
  String _currentLanguage = 'english';
  String get currentLanguage => _currentLanguage;

  // Connectivity
  bool _isOnline = false;
  bool get isOnline => _isOnline;

  // Current response
  ResponseData? _currentResponse;
  ResponseData? get currentResponse => _currentResponse;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _error;
  String? get error => _error;

  // Offline mode indicator
  bool _offlineMode = true;
  bool get offlineMode => _offlineMode;

  // API service
  final ApiService _apiService = ApiService();

  AppState() {
    _loadSettings();
  }

  // Load saved settings
  Future<void> _loadSettings() async {
    // For now, use default values since SharedPreferences is removed
    _isDarkMode = false;
    _currentLanguage = 'english';
    notifyListeners();
  }

  // Save settings
  Future<void> _saveSettings() async {
    // For now, just notify listeners since we're not persisting
    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveSettings();
    notifyListeners();
  }

  // Set language
  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    await _saveSettings();
    notifyListeners();
  }

  // Set connectivity status
  void setConnectivityStatus(bool isOnline) {
    _isOnline = isOnline;
    _offlineMode = !isOnline;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Set current response
  void setCurrentResponse(ResponseData? response) {
    _currentResponse = response;
    notifyListeners();
  }

  // Ask question to the assistant
  Future<void> askQuestion(String question) async {
    if (question.trim().isEmpty) {
      setError('Please enter a question');
      return;
    }

    setLoading(true);
    clearError();

    try {
      final response = await _apiService.askQuestion(
        question: question,
        language: _currentLanguage,
      ).timeout(
        const Duration(seconds: 60), // Add timeout to prevent hanging
        onTimeout: () {
          throw Exception('Request timed out. Please try again.');
        },
      );
      
      setCurrentResponse(response);
    } catch (e) {
      print('Error in askQuestion: $e'); // Debug print
      if (e.toString().contains('TimeoutException')) {
        setError('Request timed out. Please check your connection and try again.');
      } else {
        setError('Failed to get response: ${e.toString()}');
      }
    } finally {
      setLoading(false);
    }
  }

  // Clear current response
  void clearResponse() {
    _currentResponse = null;
    notifyListeners();
  }

  // Get available languages
  List<String> get availableLanguages => [
    'english',
    'spanish',
    'hinglish',
  ];

  // Get language display name
  String getLanguageDisplayName(String language) {
    switch (language) {
      case 'english':
        return 'English';
      case 'spanish':
        return 'Español';
      case 'hinglish':
        return 'Hinglish';
      default:
        return language;
    }
  }

  // Get language flag emoji
  String getLanguageFlag(String language) {
    switch (language) {
      case 'english':
        return '🇺🇸';
      case 'spanish':
        return '🇪🇸';
      case 'hinglish':
        return '🇮🇳';
      default:
        return '🌐';
    }
  }

  // Check if backend is available
  Future<bool> checkBackendHealth() async {
    try {
      final health = await _apiService.checkHealth();
      return health['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  // Get system status
  Map<String, dynamic> getSystemStatus() {
    return {
      'offlineMode': _offlineMode,
      'backendAvailable': _apiService.isBackendAvailable,
      'currentLanguage': _currentLanguage,
      'isDarkMode': _isDarkMode,
      'connectivity': _isOnline ? 'Online' : 'Offline',
    };
  }
}
