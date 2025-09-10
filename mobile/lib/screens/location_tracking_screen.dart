import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/location_data.dart';
import '../services/location_service.dart';
import '../widgets/offline_indicator.dart';
import 'package:disaster_response_assistant/l10n/app_localizations.dart';

class LocationTrackingScreen extends StatefulWidget {
  @override
  _LocationTrackingScreenState createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  final LocationService _locationService = LocationService();
  LocationData? _currentLocation;
  bool _isLoading = false;
  bool _isTracking = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupLocationListener();
    _getCurrentLocation(); // Get live location immediately instead of loading saved data
  }

  // Remove or comment out this method since we want live data, not saved data
  // void _loadLastKnownLocation() async {
  //   LocationData? location = await _locationService.loadLastKnownLocation();
  //   if (location != null && mounted) {
  //     setState(() {
  //       _currentLocation = location;
  //     });
  //   }
  // }

  void _setupLocationListener() {
    _locationService.locationStream.listen((location) {
      if (mounted) {
        setState(() {
          _currentLocation = location;
          _errorMessage = null;
        });
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      LocationData? location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _currentLocation = location;
        });
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.unableToGetCurrentLocation;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      _locationService.stopTracking();
      setState(() {
        _isTracking = false;
      });
    } else {
      bool success = await _locationService.startTracking();
      if (success) {
        setState(() {
          _isTracking = true;
        });
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.failedToStartLocationTracking;
        });
      }
    }
  }

  void _shareLocation() async {
    if (_currentLocation == null) return;
    
    String message = await _locationService.shareLocation(
      _currentLocation!,
      message: AppLocalizations.of(context)!.emergencyLocationMessage
    );
    
    await Share.share(message);
  }

  void _copyCoordinates() {
    if (_currentLocation == null) return;
    
    Clipboard.setData(ClipboardData(text: _currentLocation!.coordinates));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.coordinatesCopiedToClipboard))
    );
  }

  void _openInMaps() async {
    if (_currentLocation == null) return;
    
    final Uri googleMapsUri = Uri.parse(_currentLocation!.googleMapsUrl);
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    }
  }

  @override
  void dispose() {
    _locationService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.locationTracking),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _isTracking ? Icons.location_on : Icons.location_off,
                      size: 48,
                      color: _isTracking ? Colors.green : Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _isTracking ? AppLocalizations.of(context)!.locationTracking : AppLocalizations.of(context)!.locationTrackingInactive,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (_isTracking)
                      Text(
                        'Your location is being tracked for emergency assistance',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Current Location Card
            if (_currentLocation != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.currentLocation,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text('${AppLocalizations.of(context)!.coordinates}: ${_currentLocation!.coordinates}'),
                      if (_currentLocation!.address != null)
                        Text('${AppLocalizations.of(context)!.address}: ${_currentLocation!.address}'),
                      if (_currentLocation!.accuracy != null)
                        Text('${AppLocalizations.of(context)!.accuracy}: ${_currentLocation!.accuracy!.toStringAsFixed(1)}m'),
                      Text('${AppLocalizations.of(context)!.updated}: ${_currentLocation!.timestamp.toString().substring(0, 19)}'),
                      
                      SizedBox(height: 12),
                      
                      // Action Buttons
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _shareLocation,
                            icon: Icon(Icons.share),
                            label: Text(AppLocalizations.of(context)!.share),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _copyCoordinates,
                            icon: Icon(Icons.copy),
                            label: Text(AppLocalizations.of(context)!.copy),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _openInMaps,
                            icon: Icon(Icons.map),
                            label: Text(AppLocalizations.of(context)!.maps),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            
            if (_errorMessage != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            Spacer(),
            
            // Control Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _getCurrentLocation,
                  icon: _isLoading 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.my_location),
                  label: Text(_isLoading ? 'Getting Location...' : AppLocalizations.of(context)!.getCurrentLocation),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                
                SizedBox(height: 8),
                
                ElevatedButton.icon(
                  onPressed: _toggleTracking,
                  icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                  label: Text(_isTracking ? 'Stop Tracking' : AppLocalizations.of(context)!.startTracking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTracking ? Colors.red[600] : Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}