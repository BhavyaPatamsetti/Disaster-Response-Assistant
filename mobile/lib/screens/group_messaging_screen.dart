import 'package:flutter/material.dart';
import '../models/group_message.dart';
import '../services/group_messaging_service.dart';
import '../widgets/group_card.dart';
import '../widgets/create_group_dialog.dart';
import 'group_chat_screen.dart'; // Add this import
import 'package:disaster_response_assistant/l10n/app_localizations.dart';

class GroupMessagingScreen extends StatefulWidget {
  const GroupMessagingScreen({Key? key}) : super(key: key);

  @override
  State<GroupMessagingScreen> createState() => _GroupMessagingScreenState();
}

class _GroupMessagingScreenState extends State<GroupMessagingScreen> {
  final GroupMessagingService _messagingService = GroupMessagingService();
  List<MessageGroup> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
    _messagingService.createDefaultGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final groups = await _messagingService.getGroups();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading groups: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.groupMessaging),
        // backgroundColor: Colors.blue[700], // Remove this line
        // foregroundColor: Colors.white, // Remove this line
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Quick Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showCreateGroupDialog(),
                          icon: const Icon(Icons.add),
                          label: Text(AppLocalizations.of(context)!.createGroup),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _sendEmergencyBroadcast(),
                          icon: const Icon(Icons.warning),
                          label: Text(AppLocalizations.of(context)!.emergencyAlert),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // Groups List
                Expanded(
                  child: _groups.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.group,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No groups yet', // This string is not in ARB files, keeping as is
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Create a group to start messaging', // This string is not in ARB files, keeping as is
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _groups.length,
                          itemBuilder: (context, index) {
                            final group = _groups[index];
                            return GroupCard(
                              group: group,
                              onTap: () => _openGroupChat(group),
                              onDelete: () => _deleteGroup(group.id),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateGroupDialog(
        onGroupCreated: (group) async {
          await _messagingService.createGroup(group);
          _loadGroups();
        },
      ),
    );
  }

  void _openGroupChat(MessageGroup group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatScreen(group: group),
      ),
    );
  }

  Future<void> _deleteGroup(String groupId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'), // This string is not in ARB files, keeping as is
        content: const Text('Are you sure you want to delete this group? This action cannot be undone.'), // This string is not in ARB files, keeping as is
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'), // This string is not in ARB files, keeping as is
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'), // This string is not in ARB files, keeping as is
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _messagingService.deleteGroup(groupId);
      _loadGroups();
    }
  }

  void _sendEmergencyBroadcast() {
    // This will be implemented with the Emergency Broadcasts feature
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency broadcast feature coming soon!'), // This string is not in ARB files, keeping as is
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  void dispose() {
    _messagingService.dispose();
    super.dispose();
  }
}