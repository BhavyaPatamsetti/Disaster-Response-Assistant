import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';

class ContactService {
  static const String _contactsKey = 'contacts';

  Future<List<Contact>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList(_contactsKey) ?? [];
    
    return contactsJson.map((json) => Contact.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveContact(Contact contact) async {
    final contacts = await getContacts();
    contacts.add(contact);
    await _saveContacts(contacts);
  }

  Future<void> _saveContacts(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList(_contactsKey, contactsJson);
  }

  Future<void> _addDefaultContacts() async {
    final contacts = await getContacts();
    if (contacts.isEmpty) {
      final defaultContacts = [
        Contact(
          id: '1',
          name: 'John Doe',
          phoneNumber: '+1234567890',
          email: 'john@example.com',
        ),
        Contact(
          id: '2',
          name: 'Jane Smith',
          phoneNumber: '+0987654321',
          email: 'jane@example.com',
        ),
        Contact(
          id: '3',
          name: 'Emergency Contact',
          phoneNumber: '911',
        ),
      ];
      
      await _saveContacts(defaultContacts);
    }
  }

  Future<void> initializeContacts() async {
    await _addDefaultContacts();
  }
}