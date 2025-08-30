import 'package:flutter/material.dart';
import '../models/supply_item.dart';
import 'edit_supply_dialog.dart';

class SupplyItemCard extends StatelessWidget {
  final SupplyItem supply;
  final Function(SupplyItem) onUpdate;
  final Function(String) onDelete;

  const SupplyItemCard({
    Key? key,
    required this.supply,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => EditSupplyDialog(
              supply: supply,
              onUpdate: onUpdate,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supply.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                supply.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Qty: ${supply.quantity}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (supply.expirationDate != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getExpirationColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getExpirationColor().withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getExpirationIcon(),
                        color: _getExpirationColor(),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getExpirationText(),
                              style: TextStyle(
                                color: _getExpirationColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Expires: ${_formatDate(supply.expirationDate!)}',
                              style: TextStyle(
                                color: _getExpirationColor().withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (supply.notes != null && supply.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  supply.notes!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getExpirationColor() {
    if (supply.isExpired) return Colors.red;
    if (supply.daysUntilExpiration <= 7) return Colors.orange;
    if (supply.daysUntilExpiration <= 30) return Colors.yellow[700]!;
    return Colors.green;
  }

  IconData _getExpirationIcon() {
    if (supply.isExpired) return Icons.error;
    if (supply.daysUntilExpiration <= 7) return Icons.warning;
    return Icons.check_circle;
  }

  String _getExpirationText() {
    if (supply.isExpired) return 'EXPIRED';
    if (supply.daysUntilExpiration <= 0) return 'Expires today';
    if (supply.daysUntilExpiration == 1) return 'Expires tomorrow';
    if (supply.daysUntilExpiration <= 7) return 'Expires in ${supply.daysUntilExpiration} days';
    if (supply.daysUntilExpiration <= 30) return 'Expires in ${supply.daysUntilExpiration} days';
    return 'Good condition';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supply'),
        content: Text('Are you sure you want to delete "${supply.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete(supply.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}