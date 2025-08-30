class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final String? address;
  final DateTime timestamp;
  final String? emergencyType;
  final String? notes;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.address,
    required this.timestamp,
    this.emergencyType,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'accuracy': accuracy,
    'altitude': altitude,
    'address': address,
    'timestamp': timestamp.toIso8601String(),
    'emergencyType': emergencyType,
    'notes': notes,
  };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    latitude: json['latitude']?.toDouble() ?? 0.0,
    longitude: json['longitude']?.toDouble() ?? 0.0,
    accuracy: json['accuracy']?.toDouble(),
    altitude: json['altitude']?.toDouble(),
    address: json['address'],
    timestamp: DateTime.parse(json['timestamp']),
    emergencyType: json['emergencyType'],
    notes: json['notes'],
  );

  String get coordinates => '$latitude, $longitude';
  
  String get googleMapsUrl => 
    'https://www.google.com/maps?q=$latitude,$longitude';
    
  String get appleMapsUrl => 
    'http://maps.apple.com/?q=$latitude,$longitude';
}