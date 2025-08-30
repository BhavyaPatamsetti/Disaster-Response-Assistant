import 'package:flutter/material.dart';

class SupplyItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final DateTime? expirationDate;
  final DateTime dateAdded;
  final String? notes;
  final bool isExpired;
  final int daysUntilExpiration;

  SupplyItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.expirationDate,
    required this.dateAdded,
    this.notes,
  }) : isExpired = expirationDate != null && expirationDate.isBefore(DateTime.now()),
       daysUntilExpiration = expirationDate != null 
           ? expirationDate.difference(DateTime.now()).inDays 
           : -1;

  factory SupplyItem.fromJson(Map<String, dynamic> json) {
    return SupplyItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      expirationDate: json['expiration_date'] != null 
          ? DateTime.parse(json['expiration_date']) 
          : null,
      dateAdded: DateTime.parse(json['date_added']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'expiration_date': expirationDate?.toIso8601String(),
      'date_added': dateAdded.toIso8601String(),
      'notes': notes,
    };
  }
}

enum SupplyCategory {
  food('Food', Icons.restaurant),
  water('Water', Icons.water_drop),
  medical('Medical', Icons.medical_services),
  tools('Tools', Icons.build),
  clothing('Clothing', Icons.checkroom),
  communication('Communication', Icons.phone),
  shelter('Shelter', Icons.home),
  other('Other', Icons.category);

  const SupplyCategory(this.displayName, this.icon);
  
  final String displayName;
  final IconData icon;
}