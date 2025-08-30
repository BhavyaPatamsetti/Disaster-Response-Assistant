import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/main.dart'; // Import AppTheme

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Enhanced Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor, // Using accessible blue
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.emergency,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Disaster Response',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Assistant Settings',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                appState.offlineMode ? Icons.check_circle : Icons.wifi_off,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appState.offlineMode ? 'Offline Mode Active' : 'Online Mode',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Language selection
              _buildEnhancedListTile(
                icon: Icons.language,
                iconColor: AppTheme.secondaryColor, // Using accessible teal
                title: 'Language',
                subtitle: appState.getLanguageDisplayName(appState.currentLanguage),
                onTap: () => _showLanguageDialog(context, appState),
              ),

              // Theme toggle
              _buildEnhancedListTile(
                icon: appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                iconColor: appState.isDarkMode ? AppTheme.warningColor : AppTheme.primaryColor, // Using accessible colors
                title: 'Theme',
                subtitle: appState.isDarkMode ? 'Dark Mode' : 'Light Mode',
                onTap: () => appState.toggleTheme(),
                trailing: Switch(
                  value: appState.isDarkMode,
                  onChanged: (value) => appState.toggleTheme(),
                  activeColor: AppTheme.primaryColor, // Using accessible blue
                ),
              ),

              const SizedBox(height: 8),

              // Offline mode indicator
              _buildEnhancedListTile(
                icon: appState.offlineMode ? Icons.check_circle : Icons.wifi_off,
                iconColor: appState.offlineMode ? AppTheme.successColor : AppTheme.errorColor, // Using accessible colors
                title: 'Offline Mode',
                subtitle: appState.offlineMode 
                    ? 'Active - All systems operational'
                    : 'Inactive - Internet connection detected',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: appState.offlineMode ? AppTheme.successColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: appState.offlineMode ? AppTheme.successColor.withOpacity(0.3) : AppTheme.errorColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    appState.offlineMode ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: appState.offlineMode ? AppTheme.successColor : AppTheme.errorColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, indent: 16, endIndent: 16),
              const SizedBox(height: 16),

              // System status
              _buildEnhancedListTile(
                icon: Icons.info_outline,
                iconColor: AppTheme.secondaryColor, // Using accessible teal
                title: 'System Status',
                subtitle: 'View system information',
                onTap: () => _showSystemStatus(context, appState),
              ),

              // Backend connection
              _buildEnhancedListTile(
                icon: Icons.cloud_done,
                iconColor: appState.offlineMode ? AppTheme.successColor : AppTheme.errorColor, // Using accessible colors
                title: 'Backend Connection',
                subtitle: appState.offlineMode ? 'Connected' : 'Disconnected',
                onTap: () => _checkBackendConnection(context, appState),
                trailing: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: appState.offlineMode ? AppTheme.successColor : AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, indent: 16, endIndent: 16),
              const SizedBox(height: 16),

              // About
              _buildEnhancedListTile(
                icon: Icons.help_outline,
                iconColor: AppTheme.accentColor, // Using accessible orange
                title: 'About',
                subtitle: 'App information and features',
                onTap: () => _showAboutDialog(context),
              ),

              // Version info
              _buildEnhancedListTile(
                icon: Icons.info,
                iconColor: Colors.grey,
                title: 'Version',
                subtitle: '1.0.0',
                enabled: false,
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEnhancedListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? Colors.transparent : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: enabled ? null : Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: enabled ? Colors.grey[600] : Colors.grey[400],
          ),
        ),
        trailing: trailing,
        onTap: enabled ? onTap : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1), // Using accessible teal
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.language, color: AppTheme.secondaryColor, size: 24), // Using accessible teal
            ),
            const SizedBox(width: 12),
            const Text('Select Language'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: appState.availableLanguages.map((language) {
            final isSelected = language == appState.currentLanguage;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.secondaryColor.withOpacity(0.1) : Colors.transparent, // Using accessible teal
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.secondaryColor.withOpacity(0.3) : Colors.grey.withOpacity(0.2), // Using accessible teal
                ),
              ),
              child: ListTile(
                leading: Text(
                  appState.getLanguageFlag(language),
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  appState.getLanguageDisplayName(language),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppTheme.secondaryColor : null, // Using accessible teal
                  ),
                ),
                onTap: () {
                  appState.setLanguage(language);
                  Navigator.of(context).pop();
                },
                trailing: isSelected
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor, // Using accessible teal
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSystemStatus(BuildContext context, AppState appState) {
    final status = appState.getSystemStatus();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1), // Using accessible teal
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: AppTheme.secondaryColor, size: 24), // Using accessible teal
            ),
            const SizedBox(width: 12),
            const Text('System Status'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEnhancedStatusItem('Offline Mode', status['offlineMode'] ? 'Active' : 'Inactive', status['offlineMode'] ? AppTheme.successColor : AppTheme.errorColor),
            _buildEnhancedStatusItem('Backend', status['backendAvailable'] ? 'Available' : 'Unavailable', status['backendAvailable'] ? AppTheme.successColor : AppTheme.errorColor),
            _buildEnhancedStatusItem('Language', status['currentLanguage'], AppTheme.secondaryColor),
            _buildEnhancedStatusItem('Theme', status['isDarkMode'] ? 'Dark' : 'Light', AppTheme.primaryColor),
            _buildEnhancedStatusItem('Connectivity', status['connectivity'], AppTheme.warningColor),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatusItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkBackendConnection(BuildContext context, AppState appState) async {
    final isHealthy = await appState.checkBackendHealth();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isHealthy ? 'Backend is healthy and responding' : 'Backend is not responding',
          ),
          backgroundColor: isHealthy ? AppTheme.successColor : AppTheme.errorColor, // Using accessible colors
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1), // Using accessible orange
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.help_outline, color: AppTheme.accentColor, size: 24), // Using accessible orange
            ),
            const SizedBox(width: 12),
            const Text('About'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1), // Using accessible teal
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)), // Using accessible teal
              ),
              child: const Text(
                'Disaster Response Assistant is an AI-powered tool designed to provide quick, accurate information about disaster response, safety procedures, and emergency protocols.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1), // Using accessible green
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.successColor.withOpacity(0.3)), // Using accessible green
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successColor, size: 20), // Using accessible green
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Offline-first design ensures availability during emergencies',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryColor), // Using accessible blue
            ),
          ),
        ],
      ),
    );
  }
}

