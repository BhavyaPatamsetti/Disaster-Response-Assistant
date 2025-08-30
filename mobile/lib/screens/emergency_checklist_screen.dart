import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:disaster_response_assistant/models/checklist_item.dart';
import 'package:disaster_response_assistant/main.dart';

class EmergencyChecklistScreen extends StatefulWidget {
  const EmergencyChecklistScreen({super.key});

  @override
  State<EmergencyChecklistScreen> createState() => _EmergencyChecklistScreenState();
}

class _EmergencyChecklistScreenState extends State<EmergencyChecklistScreen> {
  List<ChecklistItem> _checklistItems = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Home Preparation',
    'Emergency Kit',
    'Communication Plan',
    'Important Documents',
    'Vehicle Preparation',
    'Family Safety'
  ];

  @override
  void initState() {
    super.initState();
    _loadChecklistItems();
  }

  Future<void> _loadChecklistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? checklistData = prefs.getString('emergency_checklist');
    
    if (checklistData != null) {
      final List<dynamic> jsonList = json.decode(checklistData);
      setState(() {
        _checklistItems = jsonList.map((json) => ChecklistItem.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      _initializeDefaultChecklist();
    }
  }

  void _initializeDefaultChecklist() {
    _checklistItems = [
      // Home Preparation
      ChecklistItem(
        id: '1',
        title: 'Create Emergency Plan',
        description: 'Develop a family emergency plan with meeting points and contact information',
        category: 'Home Preparation',
        priority: 1,
      ),
      ChecklistItem(
        id: '2',
        title: 'Identify Safe Rooms',
        description: 'Locate the safest rooms in your home for different emergency types',
        category: 'Home Preparation',
        priority: 1,
      ),
      ChecklistItem(
        id: '3',
        title: 'Install Smoke Detectors',
        description: 'Ensure smoke detectors are installed and batteries are fresh',
        category: 'Home Preparation',
        priority: 1,
      ),
      
      // Emergency Kit
      ChecklistItem(
        id: '4',
        title: 'Water Supply (1 gallon per person per day)',
        description: 'Store at least 3 days worth of water for each family member',
        category: 'Emergency Kit',
        priority: 1,
      ),
      ChecklistItem(
        id: '5',
        title: 'Non-perishable Food',
        description: 'Stock 3+ days of non-perishable food for each family member',
        category: 'Emergency Kit',
        priority: 1,
      ),
      ChecklistItem(
        id: '6',
        title: 'First Aid Kit',
        description: 'Assemble comprehensive first aid kit with medications',
        category: 'Emergency Kit',
        priority: 1,
      ),
      ChecklistItem(
        id: '7',
        title: 'Flashlights and Batteries',
        description: 'Multiple flashlights with extra batteries for each family member',
        category: 'Emergency Kit',
        priority: 2,
      ),
      ChecklistItem(
        id: '8',
        title: 'Battery/Hand Crank Radio',
        description: 'NOAA Weather Radio with tone alert and extra batteries',
        category: 'Emergency Kit',
        priority: 2,
      ),
      
      // Communication Plan
      ChecklistItem(
        id: '9',
        title: 'Emergency Contact List',
        description: 'Create list of local and out-of-state emergency contacts',
        category: 'Communication Plan',
        priority: 1,
      ),
      ChecklistItem(
        id: '10',
        title: 'Meeting Points',
        description: 'Establish primary and secondary family meeting locations',
        category: 'Communication Plan',
        priority: 1,
      ),
      
      // Important Documents
      ChecklistItem(
        id: '11',
        title: 'Document Copies',
        description: 'Copy important documents (ID, insurance, bank records) in waterproof container',
        category: 'Important Documents',
        priority: 2,
      ),
      ChecklistItem(
        id: '12',
        title: 'Cash Reserve',
        description: 'Keep cash in small bills and coins for emergencies',
        category: 'Important Documents',
        priority: 2,
      ),
      
      // Vehicle Preparation
      ChecklistItem(
        id: '13',
        title: 'Vehicle Emergency Kit',
        description: 'Prepare emergency kit for your vehicle with tools and supplies',
        category: 'Vehicle Preparation',
        priority: 2,
      ),
      ChecklistItem(
        id: '14',
        title: 'Full Gas Tank',
        description: 'Keep vehicle gas tank at least half full at all times',
        category: 'Vehicle Preparation',
        priority: 3,
      ),
      
      // Family Safety
      ChecklistItem(
        id: '15',
        title: 'Practice Emergency Drills',
        description: 'Conduct regular family emergency drills for different scenarios',
        category: 'Family Safety',
        priority: 1,
      ),
      ChecklistItem(
        id: '16',
        title: 'Learn Basic Skills',
        description: 'Family members learn basic first aid, CPR, and emergency skills',
        category: 'Family Safety',
        priority: 2,
      ),
    ];
    
    setState(() {
      _isLoading = false;
    });
    _saveChecklistItems();
  }

  Future<void> _saveChecklistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String checklistData = json.encode(
      _checklistItems.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('emergency_checklist', checklistData);
  }

  void _toggleItemCompletion(ChecklistItem item) {
    setState(() {
      final index = _checklistItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _checklistItems[index] = item.copyWith(
          isCompleted: !item.isCompleted,
          completedAt: !item.isCompleted ? DateTime.now() : null,
        );
      }
    });
    _saveChecklistItems();
  }

  List<ChecklistItem> get _filteredItems {
    if (_selectedCategory == 'All') {
      return _checklistItems;
    }
    return _checklistItems.where((item) => item.category == _selectedCategory).toList();
  }

  double get _completionPercentage {
    if (_checklistItems.isEmpty) return 0.0;
    final completed = _checklistItems.where((item) => item.isCompleted).length;
    return completed / _checklistItems.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Header with progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Preparedness Checklist',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete these tasks to prepare for emergencies',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Overall Progress',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(_completionPercentage * 100).round()}% Complete',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _completionPercentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Category filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ),
          
          // Checklist items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    value: item.isCompleted,
                    onChanged: (value) => _toggleItemCompletion(item),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        decoration: item.isCompleted 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description,
                          style: TextStyle(
                            decoration: item.isCompleted 
                                ? TextDecoration.lineThrough 
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(item.priority).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getPriorityText(item.priority),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getPriorityColor(item.priority),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (item.isCompleted && item.completedAt != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Completed ${_formatDate(item.completedAt!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    activeColor: AppTheme.primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return AppTheme.errorColor;
      case 2:
        return AppTheme.warningColor;
      case 3:
        return AppTheme.successColor;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'High Priority';
      case 2:
        return 'Medium Priority';
      case 3:
        return 'Low Priority';
      default:
        return 'Normal';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}