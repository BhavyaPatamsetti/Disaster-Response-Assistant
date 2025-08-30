import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/models/response_data.dart';
import 'package:disaster_response_assistant/screens/first_aid_screen.dart';
import 'package:disaster_response_assistant/screens/survival_screen.dart';
import 'package:disaster_response_assistant/screens/communications_screen.dart';
import 'package:disaster_response_assistant/screens/ask_question_screen.dart';
import 'package:disaster_response_assistant/screens/supply_inventory_screen.dart';
import 'package:disaster_response_assistant/screens/emergency_contacts_screen.dart';
import 'package:disaster_response_assistant/screens/group_messaging_screen.dart';
import 'package:disaster_response_assistant/screens/location_tracking_screen.dart'; // Add this import
import 'package:disaster_response_assistant/screens/response_screen.dart';
import 'package:disaster_response_assistant/widgets/offline_indicator.dart';
import 'package:disaster_response_assistant/widgets/settings_drawer.dart';
import 'package:disaster_response_assistant/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ResponseData? _lastResponse;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Auto-navigate to response screen when new response is received
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (appState.currentResponse != null && 
              appState.currentResponse != _lastResponse &&
              !appState.isLoading) {
            _lastResponse = appState.currentResponse;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ResponseScreen(),
              ),
            );
          }
        });

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Disaster Response Assistant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showInfoDialog(context),
                color: Colors.white,
              ),
            ],
          ),
          drawer: const SettingsDrawer(),
          body: Column(
            children: [
              // Offline indicator
              const OfflineIndicator(),
              
              // Main content
              Expanded(
                child: DefaultTabController(
                  length: 8, // Change from 7 to 8 to match the number of TabBarView children
                  child: Column(
                    children: [
                      Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: TabBar(
                          labelColor: AppTheme.primaryColor,
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: AppTheme.primaryColor,
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.medical_services),
                              text: 'First Aid',
                            ),
                            Tab(
                              icon: Icon(Icons.nature),
                              text: 'Survival',
                            ),
                            Tab(
                              icon: Icon(Icons.wifi),
                              text: 'Communic',
                            ),
                            Tab(
                              icon: Icon(Icons.inventory_2),
                              text: 'Supplies',
                            ),
                            Tab(
                              icon: Icon(Icons.contact_phone),
                              text: 'Emergency',
                            ),
                            Tab(
                              icon: Icon(Icons.group),
                              text: 'Groups',
                            ),
                            Tab(
                              icon: Icon(Icons.location_on),
                              text: 'Location',
                            ),
                            Tab(
                              icon: Icon(Icons.chat),
                              text: 'Ask Quest',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            FirstAidScreen(),
                            SurvivalScreen(),
                            CommunicationsScreen(),
                            SupplyInventoryScreen(),
                            EmergencyContactsScreen(),
                            GroupMessagingScreen(),
                            LocationTrackingScreen(),
                            AskQuestionScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Remove the response notification section completely
              // The green notification bar is no longer needed since we auto-navigate
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showEmergencyDialog(context),
            backgroundColor: AppTheme.errorColor,
            child: const Icon(
              Icons.emergency,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  // Remove the _showFullScreenResponse method since we're auto-navigating
  
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 Disaster Response Assistant'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This app provides offline-first disaster response guidance with source citations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• First Aid guidance'),
            Text('• Survival skills'),
            Text('• Emergency communications'),
            Text('• Offline operation'),
            Text('• Source citations'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning,
              color: AppTheme.errorColor,
              size: 28,
            ),
            SizedBox(width: 8),
            Text('🚨 Emergency'),
          ],
        ),
        content: const Text(
          'This is for guidance only. In a real emergency, call your local emergency services immediately.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'I Understand',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
