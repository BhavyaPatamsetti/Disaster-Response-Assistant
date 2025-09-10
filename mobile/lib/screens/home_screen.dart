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
import 'package:disaster_response_assistant/screens/location_tracking_screen.dart';
import 'package:disaster_response_assistant/screens/response_screen.dart';
import 'package:disaster_response_assistant/widgets/offline_indicator.dart';
import 'package:disaster_response_assistant/widgets/settings_drawer.dart';
import 'package:disaster_response_assistant/main.dart';
import 'package:disaster_response_assistant/l10n/app_localizations.dart';

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
            title: Row(
              children: [
                const Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.disasterResponseAssistant,
                  style: const TextStyle(
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
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: AppTheme.primaryColor,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              icon: Icon(Icons.medical_services),
                              text: AppLocalizations.of(context)!.firstAid,
                            ),
                            Tab(
                              icon: Icon(Icons.nature),
                              text: AppLocalizations.of(context)!.survival,
                            ),
                            Tab(
                              icon: Icon(Icons.wifi),
                              text: AppLocalizations.of(context)!.communications,
                            ),
                            Tab(
                              icon: Icon(Icons.inventory_2),
                              text: AppLocalizations.of(context)!.supplies,
                            ),
                            Tab(
                              icon: Icon(Icons.contact_phone),
                              text: AppLocalizations.of(context)!.emergency,
                            ),
                            Tab(
                              icon: Icon(Icons.group),
                              text: AppLocalizations.of(context)!.groups,
                            ),
                            Tab(
                              icon: Icon(Icons.location_on),
                              text: AppLocalizations.of(context)!.location,
                            ),
                            Tab(
                              icon: Icon(Icons.chat),
                              text: AppLocalizations.of(context)!.askQuestion,
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
        title: Text(AppLocalizations.of(context)!.appInfo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.appDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.features,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(AppLocalizations.of(context)!.firstAidGuidance),
            Text(AppLocalizations.of(context)!.survivalSkillsFeature),
            Text(AppLocalizations.of(context)!.emergencyCommsFeature),
            Text(AppLocalizations.of(context)!.offlineOperation),
            Text(AppLocalizations.of(context)!.sourceCitations),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.ok,
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
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: AppTheme.errorColor,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.emergencyWarning),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.emergencyDisclaimer,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: const TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
