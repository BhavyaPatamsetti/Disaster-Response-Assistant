import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_contact.dart';

class EmergencyContactsService {
  static const String _contactsKey = 'emergency_contacts';

  Future<List<EmergencyContact>> getContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getStringList(_contactsKey) ?? [];
      
      return contactsJson
          .map((json) => EmergencyContact.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addContact(EmergencyContact contact) async {
    try {
      final contacts = await getContacts();
      
      // Check if contact already exists
      if (!contacts.any((c) => c.id == contact.id)) {
        contacts.add(contact);
        await _saveContacts(contacts);
      }
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  Future<void> updateContact(EmergencyContact contact) async {
    try {
      final contacts = await getContacts();
      final index = contacts.indexWhere((c) => c.id == contact.id);
      
      if (index != -1) {
        contacts[index] = contact;
        await _saveContacts(contacts);
      }
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }

  Future<void> deleteContact(String contactId) async {
    try {
      final contacts = await getContacts();
      contacts.removeWhere((contact) => contact.id == contactId);
      await _saveContacts(contacts);
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  Future<void> _saveContacts(List<EmergencyContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = contacts
        .map((contact) => jsonEncode(contact.toJson()))
        .toList();
    
    await prefs.setStringList(_contactsKey, contactsJson);
  }
}