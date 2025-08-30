import 'package:flutter/material.dart';
import '../models/group_message.dart';
import 'member_selection_dialog.dart'; // Add this import

class GroupCard extends StatelessWidget {
  final MessageGroup group;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GroupCard({
    Key? key,
    required this.group,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getGroupColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getGroupIcon(),
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${group.memberIds.length} members',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'members':
                _showMemberManagement(context);
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'members',
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Manage Members'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Group', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getGroupColor() {
    switch (group.type) {
      case GroupType.family:
        return Colors.blue[700]!;
      case GroupType.emergency:
        return Colors.red[700]!;
      case GroupType.team:
        return Colors.green[700]!;
      case GroupType.neighborhood:
        return Colors.orange[700]!;
      default:
        return Colors.purple[700]!;
    }
  }

  IconData _getGroupIcon() {
    switch (group.type) {
      case GroupType.family:
        return Icons.family_restroom;
      case GroupType.emergency:
        return Icons.emergency;
      case GroupType.team:
        return Icons.group;
      case GroupType.neighborhood:
        return Icons.location_city;
      default:
        return Icons.chat;
    }
  }

  void _showMemberManagement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MemberSelectionDialog(
        selectedMemberIds: group.memberIds,
        onMembersSelected: (selectedIds) {
          // You'll need to add a callback to update the group
          // This would require updating the GroupCard constructor
          // to accept an onMembersUpdated callback
        },
      ),
    );
  }
}