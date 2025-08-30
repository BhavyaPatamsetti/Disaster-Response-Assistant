import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:disaster_response_assistant/models/response_data.dart';
import 'dart:async';

class ApiService {
  // Multiple backend URLs to try (fallback system)
  static const List<String> _backendUrls = [
    'http://127.0.0.1:8000',
    'http://localhost:8000',
    'http://172.20.10.3:8000',
    'http://127.0.0.1:8001',
    'http://localhost:8001',
    'http://172.20.10.3:8001',
    'http://127.0.0.1:8002',
    'http://localhost:8002',
  ];
  
  static String? _workingUrl;
  static const Duration _timeout = Duration(seconds: 30);
  static const Duration _connectionTimeout = Duration(seconds: 5);
  
  bool _isBackendAvailable = false;
  bool get isBackendAvailable => _isBackendAvailable;

  ApiService() {
    _initializeBackend();
  }

  // Initialize and find working backend URL
  Future<void> _initializeBackend() async {
    if (_workingUrl != null) {
      _isBackendAvailable = true;
      return;
    }

    print('🔍 Searching for available backend...');
    
    for (String url in _backendUrls) {
      try {
        print('🔗 Trying: $url');
        final response = await http
            .get(Uri.parse('$url/health'))
            .timeout(_connectionTimeout);

        if (response.statusCode == 200) {
          _workingUrl = url;
          _isBackendAvailable = true;
          print('✅ Backend found at: $url');
          return;
        }
      } catch (e) {
        print('❌ Failed: $url - $e');
        continue;
      }
    }
    
    print('⚠️ No backend available, will retry on next request');
    _isBackendAvailable = false;
  }

  // Enhanced health check with retry logic
  Future<Map<String, dynamic>> checkHealth() async {
    if (_workingUrl == null) {
      await _initializeBackend();
    }

    if (_workingUrl == null) {
      throw Exception('No backend servers available');
    }

    try {
      final response = await http
          .get(Uri.parse('$_workingUrl/health'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        _isBackendAvailable = true;
        return json.decode(response.body);
      } else {
        // Try to find new working URL
        _workingUrl = null;
        await _initializeBackend();
        throw Exception('Backend health check failed: ${response.statusCode}');
      }
    } catch (e) {
      _isBackendAvailable = false;
      _workingUrl = null; // Reset to search again
      throw Exception('Backend health check failed: $e');
    }
  }

  // Enhanced askQuestion with automatic retry and fallback
  Future<ResponseData> askQuestion({
    required String question,
    String language = 'english',
    int topK = 5,
    double similarityThreshold = 0.35,
  }) async {
    print('🤖 API Service: Asking question: $question');
    
    // Ensure we have a working backend
    if (_workingUrl == null) {
      await _initializeBackend();
    }

    // Try up to 3 times with different URLs if needed
    for (int attempt = 1; attempt <= 3; attempt++) {
      if (_workingUrl == null) {
        await _initializeBackend();
      }

      if (_workingUrl == null) {
        throw Exception('No backend servers available after $attempt attempts');
      }

      try {
        print('🔄 Attempt $attempt: Using $_workingUrl');
        
        final response = await http
            .post(
              Uri.parse('$_workingUrl/ask'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode({
                'question': question,
                'language': language,
                'top_k': topK,
                'similarity_threshold': similarityThreshold,
              }),
            )
            .timeout(_timeout);

        print('📡 Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          _isBackendAvailable = true;
          final data = json.decode(response.body);
          print('✅ Success: Got response from backend');
          return ResponseData.fromJson(data);
        } else {
          print('❌ Bad response: ${response.statusCode} - ${response.body}');
          throw Exception('Server returned ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        print('❌ Attempt $attempt failed: $e');
        _workingUrl = null; // Reset to try next URL
        _isBackendAvailable = false;
        
        if (attempt == 3) {
          throw Exception('All backend attempts failed. Last error: $e');
        }
        
        // Wait a bit before retrying
        await Future.delayed(Duration(milliseconds: 500));
      }
    }

    throw Exception('Failed to get response after all attempts');
  }

  // Get system status
  Future<Map<String, dynamic>> getSystemStatus() async {
    if (_workingUrl == null) {
      await _initializeBackend();
    }

    if (_workingUrl == null) {
      return {
        'status': 'offline',
        'backend_available': false,
        'message': 'No backend servers available'
      };
    }

    try {
      final response = await http
          .get(Uri.parse('$_workingUrl/status'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        data['backend_url'] = _workingUrl;
        return data;
      }
    } catch (e) {
      print('Status check failed: $e');
    }

    return {
      'status': 'error',
      'backend_available': false,
      'backend_url': _workingUrl,
      'message': 'Backend status check failed'
    };
  }

  // Force refresh backend connection
  Future<void> refreshConnection() async {
    print('🔄 Forcing backend connection refresh...');
    _workingUrl = null;
    _isBackendAvailable = false;
    await _initializeBackend();
  }

  // Get current backend info
  String? get currentBackendUrl => _workingUrl;
  
  // Check if specific URL is working
  Future<bool> testUrl(String url) async {
    try {
      final response = await http
          .get(Uri.parse('$url/health'))
          .timeout(_connectionTimeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
