import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/widgets/prompt_button.dart';

class SurvivalScreen extends StatefulWidget {
  const SurvivalScreen({super.key});

  @override
  State<SurvivalScreen> createState() => _SurvivalScreenState();
}

class _SurvivalScreenState extends State<SurvivalScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              '🏕️ ${AppLocalizations.of(context)!.survivalSkills}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.learnEssentialSurvival,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Quick prompt buttons
            Text(
              AppLocalizations.of(context)!.essentialSkills,
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
                      icon: '💧',
                      title: AppLocalizations.of(context)!.water,
                      question: AppLocalizations.of(context)!.waterQuestion,
                      onPressed: () => _askQuestion(
                        'How do I make drinking water safe after flooding?',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PromptButton(
                      icon: '🏠',
                      title: AppLocalizations.of(context)!.shelter,
                      question: AppLocalizations.of(context)!.shelterQuestion,
                      onPressed: () => _askQuestion(
                        'How do I build emergency shelter in cold weather?',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Second row of buttons
            SizedBox(
              height: 140,
              child: Row(
                children: [
                  Expanded(
                    child: PromptButton(
                      icon: '🔥',
                      title: AppLocalizations.of(context)!.fire,
                      question: AppLocalizations.of(context)!.fireQuestion,
                      onPressed: () => _askQuestion(
                        'How do I start a fire safely in wet conditions?',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PromptButton(
                      icon: '🍎',
                      title: AppLocalizations.of(context)!.food,
                      question: AppLocalizations.of(context)!.foodQuestion,
                      onPressed: () => _askQuestion(
                        'What food is safe to eat in emergency situations?',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Third row of buttons
            SizedBox(
              height: 140,
              child: Row(
                children: [
                  Expanded(
                    child: PromptButton(
                      icon: '🧼',
                      title: AppLocalizations.of(context)!.sanitation,
                      question: AppLocalizations.of(context)!.sanitationQuestion,
                      onPressed: () => _askQuestion(
                        'How do I maintain hygiene without running water?',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PromptButton(
                      icon: '🧭',
                      title: AppLocalizations.of(context)!.navigation,
                      question: AppLocalizations.of(context)!.navigationQuestion,
                      onPressed: () => _askQuestion(
                        'How do I navigate without GPS or compass?',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Custom question input
            Text(
              AppLocalizations.of(context)!.askCustomSurvivalQuestion,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.survivalQuestionHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.forest),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _askCustomQuestion(),
                ),
              ),
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _askCustomQuestion,
                icon: const Icon(Icons.search),
                label: Text(AppLocalizations.of(context)!.getGuidance),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.survivalTips,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.tipPrioritizeShelter,
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.tipStayCalmSurvival,
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.tipConserveEnergy,
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.tipSignalForHelp,
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _askQuestion(String question) {
    context.read<AppState>().askQuestion(question);
  }

  void _askCustomQuestion() {
    final question = _questionController.text.trim();
    if (question.isNotEmpty) {
      _askQuestion(question);
      _questionController.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterQuestion),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
