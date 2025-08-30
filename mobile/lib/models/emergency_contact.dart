import 'package:flutter/material.dart';

class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final ContactType type;
  final bool isPrimary;
  final DateTime dateAdded;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.type,
    this.isPrimary = false,
    required this.dateAdded,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      relationship: json['relationship'],
      type: ContactType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContactType.personal,
      ),
      isPrimary: json['is_primary'] ?? false,
      dateAdded: DateTime.parse(json['date_added']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'relationship': relationship,
      'type': type.name,
      'is_primary': isPrimary,
      'date_added': dateAdded.toIso8601String(),
    };
  }
}

enum ContactType {
  emergency('Emergency Services', Icons.local_hospital),
  personal('Personal Contact', Icons.person),
  family('Family Member', Icons.family_restroom),
  work('Work Contact', Icons.work),
  neighbor('Neighbor', Icons.home);

  const ContactType(this.displayName, this.icon);
  
  final String displayName;
  final IconData icon;
}