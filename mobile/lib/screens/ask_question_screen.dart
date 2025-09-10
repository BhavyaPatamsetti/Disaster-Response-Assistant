import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/l10n/app_localizations.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();

  @override
  void dispose() {
    _questionController.dispose();
    _questionFocusNode.dispose();
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
              '❓ ${AppLocalizations.of(context)!.askAnyQuestion}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.askAnyDisasterQuestion,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Question input
            TextField(
              controller: _questionController,
              focusNode: _questionFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.questionInputHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.question_answer),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _askQuestion(),
                ),
              ),
              maxLines: 5,
              minLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _askQuestion(),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _askQuestion,
                    icon: const Icon(Icons.search),
                    label: Text(AppLocalizations.of(context)!.getAnswer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearQuestion,
                    icon: const Icon(Icons.clear),
                    label: Text(AppLocalizations.of(context)!.clear),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Example questions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '💡 ${AppLocalizations.of(context)!.exampleQuestions}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildExampleQuestion(
                    AppLocalizations.of(context)!.exampleEvacuationPlan,
                    () => _setExampleQuestion(AppLocalizations.of(context)!.exampleEvacuationPlan),
                  ),
                  _buildExampleQuestion(
                    AppLocalizations.of(context)!.example72HourKit,
                    () => _setExampleQuestion(AppLocalizations.of(context)!.example72HourKit),
                  ),
                  _buildExampleQuestion(
                    AppLocalizations.of(context)!.examplePanicAttack,
                    () => _setExampleQuestion(AppLocalizations.of(context)!.examplePanicAttack),
                  ),
                  _buildExampleQuestion(
                    AppLocalizations.of(context)!.exampleHeatStroke,
                    () => _setExampleQuestion(AppLocalizations.of(context)!.exampleHeatStroke),
                  ),
                  _buildExampleQuestion(
                    AppLocalizations.of(context)!.examplePurifyWater,
                    () => _setExampleQuestion(AppLocalizations.of(context)!.examplePurifyWater),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tips section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.tipsForBetterAnswers,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.tipBeSpecific,
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.tipMentionConditions,
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.tipAskImmediate,
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.tipIncludeLocation,
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQuestion(String question, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.orange[400],
            ),
          ],
        ),
      ),
    );
  }

  void _askQuestion() {
    final question = _questionController.text.trim();
    if (question.isNotEmpty) {
      context.read<AppState>().askQuestion(question);
      _questionFocusNode.unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterQuestion),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _clearQuestion() {
    _questionController.clear();
    _questionFocusNode.requestFocus();
  }

  void _setExampleQuestion(String question) {
    _questionController.text = question;
    _questionFocusNode.requestFocus();
  }
}
