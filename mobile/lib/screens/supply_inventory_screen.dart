import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/supply_item.dart';
import '../widgets/supply_item_card.dart';
import '../widgets/add_supply_dialog.dart';
import '../widgets/edit_supply_dialog.dart';

class SupplyInventoryScreen extends StatefulWidget {
  const SupplyInventoryScreen({super.key});

  @override
  State<SupplyInventoryScreen> createState() => _SupplyInventoryScreenState();
}

class _SupplyInventoryScreenState extends State<SupplyInventoryScreen> {
  List<SupplyItem> _supplies = [];
  String _selectedCategory = 'All';
  bool _showExpiredOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSupplies();
  }

  Future<void> _loadSupplies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final suppliesJson = prefs.getStringList('emergency_supplies') ?? [];
      
      if (mounted) {
        setState(() {
          _supplies = suppliesJson
              .map((json) => SupplyItem.fromJson(jsonDecode(json)))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSupplies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final suppliesJson = _supplies
          .map((supply) => jsonEncode(supply.toJson()))
          .toList();
      await prefs.setStringList('emergency_supplies', suppliesJson);
    } catch (e) {
      debugPrint('Error saving supplies: $e');
    }
  }

  void _addSupply(SupplyItem supply) {
    setState(() {
      _supplies.add(supply);
    });
    _saveSupplies();
  }

  void _updateSupply(SupplyItem updatedSupply) {
    setState(() {
      final index = _supplies.indexWhere((s) => s.id == updatedSupply.id);
      if (index != -1) {
        _supplies[index] = updatedSupply;
      }
    });
    _saveSupplies();
  }

  void _deleteSupply(String id) {
    setState(() {
      _supplies.removeWhere((s) => s.id == id);
    });
    _saveSupplies();
  }

  List<SupplyItem> get _filteredSupplies {
    var filtered = _supplies;
    
    if (_selectedCategory != 'All') {
      filtered = filtered.where((s) => s.category == _selectedCategory).toList();
    }
    
    if (_showExpiredOnly) {
      filtered = filtered.where((s) => s.isExpired || s.daysUntilExpiration <= 7).toList();
    }
    
    return filtered..sort((a, b) {
      if (a.isExpired && !b.isExpired) return -1;
      if (!a.isExpired && b.isExpired) return 1;
      if (a.daysUntilExpiration != -1 && b.daysUntilExpiration != -1) {
        return a.daysUntilExpiration.compareTo(b.daysUntilExpiration);
      }
      return a.name.compareTo(b.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _supplies.length;
    final expiredItems = _supplies.where((s) => s.isExpired).length;
    final expiringItems = _supplies.where((s) => !s.isExpired && s.daysUntilExpiration <= 7 && s.daysUntilExpiration >= 0).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply Inventory'),
        // backgroundColor: Colors.green[700], // Remove this line
        // foregroundColor: Colors.white, // Remove this line
        actions: [
          IconButton(
            icon: Icon(_showExpiredOnly ? Icons.warning : Icons.warning_outlined),
            onPressed: () {
              setState(() {
                _showExpiredOnly = !_showExpiredOnly;
              });
            },
            tooltip: 'Show expiring items',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistics
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Total', totalItems.toString(), Colors.blue),
                      _buildStatItem('Expired', expiredItems.toString(), Colors.red),
                      _buildStatItem('Expiring', expiringItems.toString(), Colors.orange),
                    ],
                  ),
                ),
                // Category filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // All category chip
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All'),
                            selected: _selectedCategory == 'All',
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = 'All';
                              });
                            },
                          ),
                        ),
                        // Category chips
                        ...SupplyCategory.values.map((category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.displayName),
                            selected: _selectedCategory == category.name,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category.name;
                              });
                            },
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Supply list
                Expanded(
                  child: _filteredSupplies.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _supplies.isEmpty
                                    ? 'No supplies added yet'
                                    : 'No supplies match your filters',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _supplies.isEmpty
                                    ? 'Tap the + button to add your first supply'
                                    : 'Try adjusting your category or expiration filters',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredSupplies.length,
                          itemBuilder: (context, index) {
                            final supply = _filteredSupplies[index];
                            return SupplyItemCard(
                              supply: supply,
                              onUpdate: _updateSupply,
                              onDelete: _deleteSupply,
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddSupplyDialog(
              onAdd: _addSupply,
            ),
          );
        },
        // backgroundColor: Colors.green[700], // Remove this line
        // child: const Icon(Icons.add, color: Colors.white), // Update this line
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}