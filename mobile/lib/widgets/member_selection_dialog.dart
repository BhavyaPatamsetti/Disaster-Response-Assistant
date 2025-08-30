import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class MemberSelectionDialog extends StatefulWidget {
  final List<String> selectedMemberIds;
  final Function(List<String>) onMembersSelected;

  const MemberSelectionDialog({
    Key? key,
    required this.selectedMemberIds,
    required this.onMembersSelected,
  }) : super(key: key);

  @override
  State<MemberSelectionDialog> createState() => _MemberSelectionDialogState();
}

class _MemberSelectionDialogState extends State<MemberSelectionDialog> {
  final ContactService _contactService = ContactService();
  List<Contact> _contacts = [];
  List<String> _selectedIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedMemberIds);
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      await _contactService.initializeContacts();
      final contacts = await _contactService.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Members'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        final contact = _contacts[index];
                        final isSelected = _selectedIds.contains(contact.id);
                        
                        return CheckboxListTile(
                          title: Text(contact.name),
                          subtitle: Text(contact.phoneNumber),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedIds.add(contact.id);
                              } else {
                                _selectedIds.remove(contact.id);
                              }
                            });
                          },
                          secondary: CircleAvatar(
                            child: Text(contact.name[0].toUpperCase()),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text(
                    '${_selectedIds.length} members selected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onMembersSelected(_selectedIds);
            Navigator.pop(context);
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}