import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/widgets/prompt_button.dart';
import 'package:disaster_response_assistant/l10n/app_localizations.dart';

class CommunicationsScreen extends StatefulWidget {
  const CommunicationsScreen({super.key});

  @override
  State<CommunicationsScreen> createState() => _CommunicationsScreenState();
}

class _CommunicationsScreenState extends State<CommunicationsScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  AppLocalizations.of(context)!.emergencyComms,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.templatesGuidance,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick prompt buttons
                Text(
                  AppLocalizations.of(context)!.commTemplates,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Add your communication prompt buttons here
                PromptButton(
                  icon: '📱',
                  title: AppLocalizations.of(context)!.checkIn,
                  question: AppLocalizations.of(context)!.generateSMSCheckIn,
                  onPressed: appState.isLoading 
                      ? () {} // Empty function when loading
                      : () => _askQuestion(AppLocalizations.of(context)!.generateSMSCheckIn),
                ),
                
                // Add more buttons as needed
              ],
            ),
          );
        },
      ),
    );
  }

  void _askQuestion(String question) {
    context.read<AppState>().askQuestion(question);
  }
}
