import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/group_message.dart';

class GroupMessagingService {
  static const String _groupsKey = 'message_groups';
  static const String _messagesKey = 'group_messages';
  
  final StreamController<List<GroupMessage>> _messagesController = 
      StreamController<List<GroupMessage>>.broadcast();
  final StreamController<List<MessageGroup>> _groupsController = 
      StreamController<List<MessageGroup>>.broadcast();

  Stream<List<GroupMessage>> get messagesStream => _messagesController.stream;
  Stream<List<MessageGroup>> get groupsStream => _groupsController.stream;

  // Groups Management
  Future<List<MessageGroup>> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getStringList(_groupsKey) ?? [];
    final groups = groupsJson
        .map((json) => MessageGroup.fromJson(jsonDecode(json)))
        .toList();
    _groupsController.add(groups);
    return groups;
  }

  Future<void> createGroup(MessageGroup group) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    groups.add(group);
    
    final groupsJson = groups.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_groupsKey, groupsJson);
    _groupsController.add(groups);
  }

  Future<void> updateGroup(MessageGroup group) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    final index = groups.indexWhere((g) => g.id == group.id);
    
    if (index != -1) {
      groups[index] = group;
      final groupsJson = groups.map((g) => jsonEncode(g.toJson())).toList();
      await prefs.setStringList(_groupsKey, groupsJson);
      _groupsController.add(groups);
    }
  }

  Future<void> deleteGroup(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = await getGroups();
    groups.removeWhere((g) => g.id == groupId);
    
    final groupsJson = groups.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_groupsKey, groupsJson);
    
    // Also delete all messages for this group
    await _deleteMessagesForGroup(groupId);
    _groupsController.add(groups);
  }

  // Messages Management
  Future<List<GroupMessage>> getMessagesForGroup(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList('${_messagesKey}_$groupId') ?? [];
    final messages = messagesJson
        .map((json) => GroupMessage.fromJson(jsonDecode(json)))
        .toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  Future<void> sendMessage(GroupMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await getMessagesForGroup(message.groupId);
    messages.add(message);
    
    final messagesJson = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('${_messagesKey}_${message.groupId}', messagesJson);
    _messagesController.add(messages);
  }

  Future<void> _deleteMessagesForGroup(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_messagesKey}_$groupId');
  }

  // Create default emergency groups
  Future<void> createDefaultGroups() async {
    final groups = await getGroups();
    if (groups.isEmpty) {
      final defaultGroups = [
        MessageGroup(
          id: 'family_group',
          name: 'Family Emergency',
          description: 'Emergency coordination with family members',
          memberIds: [],
          createdBy: 'system',
          createdAt: DateTime.now(),
          type: GroupType.family,
        ),
        MessageGroup(
          id: 'emergency_team',
          name: 'Emergency Response Team',
          description: 'Coordinate with local emergency responders',
          memberIds: [],
          createdBy: 'system',
          createdAt: DateTime.now(),
          type: GroupType.emergency,
        ),
      ];
      
      for (final group in defaultGroups) {
        await createGroup(group);
      }
    }
  }

  void dispose() {
    _messagesController.close();
    _groupsController.close();
  }
}