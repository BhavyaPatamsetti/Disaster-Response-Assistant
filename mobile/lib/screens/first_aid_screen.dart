import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/l10n/app_localizations.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/widgets/prompt_button.dart';
import 'package:disaster_response_assistant/main.dart'; // Import AppTheme

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
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
                  AppLocalizations.of(context)!.firstAid,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.selectFirstAidScenario,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Status indicator
                if (appState.isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.gettingResponseFromAI,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Error display
                if (appState.error != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.errorColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            appState.error!,
                            style: const TextStyle(
                              color: AppTheme.errorColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppTheme.errorColor),
                          onPressed: () => appState.clearError(),
                        ),
                      ],
                    ),
                  ),

                // Quick prompt buttons
                Text(
                  AppLocalizations.of(context)!.quickScenarios,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // First row of buttons
                SizedBox(
                  height: 140,
                  child: Row(
                    children: [
                      Expanded(
                        child: PromptButton(
                          icon: '🩸',
                          title: AppLocalizations.of(context)!.bleeding,
                          question: AppLocalizations.of(context)!.bleedingQuestion,
                          onPressed: appState.isLoading 
                              ? () {} // Empty function when loading
                              : () => _askQuestion(
                                AppLocalizations.of(context)!.bleedingQuestion,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PromptButton(
                          icon: '💓',
                          title: AppLocalizations.of(context)!.cpr,
                          question: AppLocalizations.of(context)!.cprQuestion,
                          onPressed: appState.isLoading 
                              ? () {} // Empty function when loading
                              : () => _askQuestion(
                                AppLocalizations.of(context)!.cprQuestion,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Second row of buttons
                SizedBox(
                  height: 140,
                  child: Row(
                    children: [
                      Expanded(
                        child: PromptButton(
                          icon: '🔥',
                          title: AppLocalizations.of(context)!.burns,
                          question: AppLocalizations.of(context)!.burnsQuestion,
                          onPressed: appState.isLoading 
                              ? () {} // Empty function when loading
                              : () => _askQuestion(
                                AppLocalizations.of(context)!.burnsQuestion,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PromptButton(
                          icon: '💊',
                          title: AppLocalizations.of(context)!.choking,
                          question: AppLocalizations.of(context)!.chokingQuestion,
                          onPressed: appState.isLoading 
                              ? () {} // Empty function when loading
                              : () => _askQuestion(
                                AppLocalizations.of(context)!.chokingQuestion,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Third row of buttons
                SizedBox(
                  height: 140,
                  child: Row(
                    children: [
                      Expanded(
                        child: PromptButton(
                          icon: '🦴',
                          title: AppLocalizations.of(context)!.fractures,
                          question: AppLocalizations.of(context)!.fracturesQuestion,
                          onPressed: appState.isLoading 
                              ? () {} // Empty function when loading
                              : () => _askQuestion(
                                AppLocalizations.of(context)!.fracturesQuestion,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PromptButton(
                          icon: '😵',
                          title: AppLocalizations.of(context)!.unconscious,
                          question: AppLocalizations.of(context)!.unconsciousQuestion,
                          onPressed: appState.isLoading 
                              ? () {} // Empty function when loading
                              : () => _askQuestion(
                                AppLocalizations.of(context)!.unconsciousQuestion,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Custom question section
                Text(
                  AppLocalizations.of(context)!.askYourOwnQuestion,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.questionHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: appState.isLoading ? null : () => _askCustomQuestion(),
                    ),
                  ),
                  maxLines: 3,
                  minLines: 2,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: appState.isLoading ? null : _askCustomQuestion,
                    icon: const Icon(Icons.search),
                    label: Text(appState.isLoading ? AppLocalizations.of(context)!.gettingResponse : AppLocalizations.of(context)!.getGuidance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor, // Using accessible blue
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tips section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1), // Using accessible teal
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.secondaryColor, // Using accessible teal
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.firstAidTips,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor, // Using accessible teal
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.tipCallEmergency,
                        style: const TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                      Text(
                        AppLocalizations.of(context)!.tipKeepSupplies,
                        style: const TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                      Text(
                        AppLocalizations.of(context)!.tipStayCalm,
                        style: const TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                      Text(
                        AppLocalizations.of(context)!.tipDontMove,
                        style: const TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                    ],
                  ),
                ),
                
                // Add extra bottom spacing
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _askQuestion(String question) {
    print('Asking question: $question'); // Debug print
    context.read<AppState>().askQuestion(question);
  }

  void _askCustomQuestion() {
    final question = _questionController.text.trim();
    if (question.isNotEmpty) {
      print('Asking custom question: $question');
      _askQuestion(question);
      _questionController.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterQuestion),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    }
  }
}


