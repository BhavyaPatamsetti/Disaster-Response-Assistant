import 'package:flutter/material.dart';
import '../models/group_message.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';
import 'member_selection_dialog.dart';

class CreateGroupDialog extends StatefulWidget {
  final Function(MessageGroup) onGroupCreated;

  const CreateGroupDialog({
    Key? key,
    required this.onGroupCreated,
  }) : super(key: key);

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ContactService _contactService = ContactService();
  GroupType _selectedType = GroupType.family;
  List<String> _selectedMemberIds = [];
  List<Contact> _allContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    await _contactService.initializeContacts();
    final contacts = await _contactService.getContacts();
    setState(() {
      _allContacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Group'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<GroupType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Group Type',
                border: OutlineInputBorder(),
              ),
              items: GroupType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getGroupTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text('Members (${_selectedMemberIds.length})'),
              subtitle: _selectedMemberIds.isEmpty
                  ? const Text('No members selected')
                  : Text('${_selectedMemberIds.length} members selected'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showMemberSelection,
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
          onPressed: _createGroup,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _showMemberSelection() {
    showDialog(
      context: context,
      builder: (context) => MemberSelectionDialog(
        selectedMemberIds: _selectedMemberIds,
        onMembersSelected: (selectedIds) {
          setState(() {
            _selectedMemberIds = selectedIds;
          });
        },
      ),
    );
  }

  String _getGroupTypeName(GroupType type) {
    switch (type) {
      case GroupType.family:
        return 'Family';
      case GroupType.emergency:
        return 'Emergency';
      case GroupType.team:
        return 'Team';
      case GroupType.neighborhood:
        return 'Neighborhood';
      case GroupType.custom:
        return 'Custom';
    }
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      final group = MessageGroup(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        memberIds: _selectedMemberIds,
        createdBy: 'current_user',
        createdAt: DateTime.now(),
        type: _selectedType,
      );
      
      widget.onGroupCreated(group);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}