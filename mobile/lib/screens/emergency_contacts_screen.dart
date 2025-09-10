import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact.dart';
import '../services/emergency_contacts_service.dart';
import '../widgets/add_contact_dialog.dart';
import '../widgets/emergency_contact_card.dart';
import 'package:disaster_response_assistant/l10n/app_localizations.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final EmergencyContactsService _contactsService = EmergencyContactsService();
  List<EmergencyContact> _contacts = [];
  bool _isLoading = true;
  ContactType _selectedFilter = ContactType.emergency;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _addDefaultEmergencyContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final contacts = await _contactsService.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorLoadingContacts}: $e')),
        );
      }
    }
  }

  Future<void> _addDefaultEmergencyContacts() async {
    final defaultContacts = [
      EmergencyContact(
        id: 'emergency_911',
        name: AppLocalizations.of(context)!.emergencyServices,
        phoneNumber: '911',
        relationship: 'Emergency',
        type: ContactType.emergency,
        isPrimary: true,
        dateAdded: DateTime.now(),
      ),
      EmergencyContact(
        id: 'poison_control',
        name: AppLocalizations.of(context)!.poisonControl,
        phoneNumber: '1-800-222-1222',
        relationship: 'Emergency',
        type: ContactType.emergency,
        dateAdded: DateTime.now(),
      ),
    ];

    for (final contact in defaultContacts) {
      await _contactsService.addContact(contact);
    }
    _loadContacts();
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.couldNotMakeCall)),
        );
      }
    }
  }

  List<EmergencyContact> get _filteredContacts {
    return _contacts.where((contact) => contact.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.emergencyContacts),
        // backgroundColor: Colors.red[700], // Remove this line
        // foregroundColor: Colors.white, // Remove this line
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddContactDialog(
                  onAdd: (contact) async {
                    await _contactsService.addContact(contact);
                    _loadContacts();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Quick Emergency Dial Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.quickEmergencyDial,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildQuickDialButton('911', AppLocalizations.of(context)!.emergencyServices, Icons.local_hospital),
                          _buildQuickDialButton('1-800-222-1222', AppLocalizations.of(context)!.poisonControl, Icons.warning),
                        ],
                      ),
                    ],
                  ),
                ),
                // Filter tabs
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ContactType.values.map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type.displayName),
                          selected: _selectedFilter == type,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = type;
                            });
                          },
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                // Contacts list
                Expanded(
                  child: _filteredContacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.contacts,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No ${_selectedFilter.displayName.toLowerCase()} contacts',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.tapPlusButton,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredContacts.length,
                          itemBuilder: (context, index) {
                            final contact = _filteredContacts[index];
                            return EmergencyContactCard(
                              contact: contact,
                              onCall: () => _makeCall(contact.phoneNumber),
                              onDelete: () async {
                                await _contactsService.deleteContact(contact.id);
                                _loadContacts();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuickDialButton(String number, String label, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () => _makeCall(number),
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.red[700], // Remove this line
            // foregroundColor: Colors.white, // Remove this line
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                number,
                style: const TextStyle(
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}