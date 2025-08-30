import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_data.dart';
import 'dart:convert';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamController<LocationData>? _locationController;
  Timer? _locationTimer;
  bool _isTracking = false;
  LocationData? _lastKnownLocation;

  Stream<LocationData> get locationStream {
    _locationController ??= StreamController<LocationData>.broadcast();
    return _locationController!.stream;
  }

  bool get isTracking => _isTracking;
  LocationData? get lastKnownLocation => _lastKnownLocation;

  // Check and request location permissions
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Open app settings
        await openAppSettings();
        return false;
      }
      
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  // Get current location once
  Future<LocationData?> getCurrentLocation() async {
    try {
      if (!await requestLocationPermission()) {
        throw Exception('Location permission denied');
      }

      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Location services are disabled');
      }

      // Improved location settings for better accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best, // Changed from high to best
        timeLimit: Duration(seconds: 30), // Increased timeout
        forceAndroidLocationManager: false, // Use newer location APIs
      );

      String? address;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address = '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (e) {
        print('Error getting address: $e');
      }

      _lastKnownLocation = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        address: address,
        timestamp: DateTime.now(),
      );

      await _saveLocationToStorage(_lastKnownLocation!);
      return _lastKnownLocation;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Start continuous location tracking
  Future<bool> startTracking({int intervalSeconds = 30}) async {
    if (_isTracking) return true;
    
    if (!await requestLocationPermission()) {
      return false;
    }

    _isTracking = true;
    _locationController ??= StreamController<LocationData>.broadcast();

    // Get initial location
    await getCurrentLocation();
    if (_lastKnownLocation != null) {
      _locationController!.add(_lastKnownLocation!);
    }

    // Start periodic updates
    _locationTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) async {
        LocationData? location = await getCurrentLocation();
        if (location != null) {
          _locationController!.add(location);
        }
      },
    );

    return true;
  }

  // Stop location tracking
  void stopTracking() {
    _isTracking = false;
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  // Share location via emergency contacts
  Future<String> shareLocation(LocationData location, {String? message}) async {
    String locationMessage = message ?? 'Emergency! I need help at this location:';
    locationMessage += '\n\nCoordinates: ${location.coordinates}';
    if (location.address != null) {
      locationMessage += '\nAddress: ${location.address}';
    }
    locationMessage += '\nGoogle Maps: ${location.googleMapsUrl}';
    locationMessage += '\nTime: ${location.timestamp.toString()}';
    
    return locationMessage;
  }

  // Save location to local storage
  Future<void> _saveLocationToStorage(LocationData location) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_known_location', jsonEncode(location.toJson()));
      
      // Save to location history
      List<String> history = prefs.getStringList('location_history') ?? [];
      history.add(jsonEncode(location.toJson()));
      
      // Keep only last 50 locations
      if (history.length > 50) {
        history = history.sublist(history.length - 50);
      }
      
      await prefs.setStringList('location_history', history);
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  // Load last known location from storage
  Future<LocationData?> loadLastKnownLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? locationJson = prefs.getString('last_known_location');
      if (locationJson != null) {
        _lastKnownLocation = LocationData.fromJson(jsonDecode(locationJson));
        return _lastKnownLocation;
      }
    } catch (e) {
      print('Error loading location: $e');
    }
    return null;
  }

  // Get location history
  Future<List<LocationData>> getLocationHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList('location_history') ?? [];
      return history.map((json) => LocationData.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      print('Error loading location history: $e');
      return [];
    }
  }

  // Dispose resources
  void dispose() {
    stopTracking();
    _locationController?.close();
    _locationController = null;
  }
}