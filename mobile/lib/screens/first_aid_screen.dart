import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
// Remove this line:
// import 'package:disaster_response_assistant/models/response_data.dart';
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
                  'First Aid Guidance',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a first aid scenario or ask a specific question:',
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
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Getting response from AI...',
                          style: TextStyle(
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
                  'Quick Scenarios:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // First row of buttons
                Row(
                  children: [
                    Expanded(
                      child: PromptButton(
                        icon: '🩸',
                        title: 'Bleeding',
                        question: 'Person has heavy bleeding from [location]—what do I do first?',
                        onPressed: appState.isLoading 
                            ? () {} // Empty function when loading
                            : () => _askQuestion(
                              'Person has heavy bleeding from forearm—what do I do first?',
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PromptButton(
                        icon: '💓',
                        title: 'CPR',
                        question: 'Someone is unconscious and not breathing—how do I perform CPR?',
                        onPressed: appState.isLoading 
                            ? () {} // Empty function when loading
                            : () => _askQuestion(
                              'Someone is unconscious and not breathing—how do I perform CPR?',
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Second row of buttons
                Row(
                  children: [
                    Expanded(
                      child: PromptButton(
                        icon: '🔥',
                        title: 'Burns',
                        question: 'Person has [degree] burns on [location]—immediate treatment?',
                        onPressed: appState.isLoading 
                            ? () {} // Empty function when loading
                            : () => _askQuestion(
                              'Person has second-degree burns on hand—immediate treatment?',
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PromptButton(
                        icon: '💊',
                        title: 'Choking',
                        question: 'Person is choking and cannot speak—what is the Heimlich maneuver?',
                        onPressed: appState.isLoading 
                            ? () {} // Empty function when loading
                            : () => _askQuestion(
                              'Person is choking and cannot speak—what is the Heimlich maneuver?',
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Third row of buttons
                Row(
                  children: [
                    Expanded(
                      child: PromptButton(
                        icon: '🦴',
                        title: 'Fractures',
                        question: 'Person has suspected broken bone in [location]—first aid steps?',
                        onPressed: appState.isLoading 
                            ? () {} // Empty function when loading
                            : () => _askQuestion(
                              'Person has suspected broken bone in arm—first aid steps?',
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PromptButton(
                        icon: '😵',
                        title: 'Unconscious',
                        question: 'Person is unconscious but breathing—what should I do?',
                        onPressed: appState.isLoading 
                            ? () {} // Empty function when loading
                            : () => _askQuestion(
                              'Person is unconscious but breathing—what should I do?',
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Custom question section
                Text(
                  'Ask Your Own Question:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: 'e.g., How do I treat a sprained ankle?',
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
                    label: Text(appState.isLoading ? 'Getting Response...' : 'Get Guidance'),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.secondaryColor, // Using accessible teal
                          ),
                          SizedBox(width: 8),
                          Text(
                            'First Aid Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryColor, // Using accessible teal
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Always call emergency services for serious injuries',
                        style: TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                      Text(
                        '• Keep first aid supplies readily available',
                        style: TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                      Text(
                        '• Stay calm and assess the situation first',
                        style: TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
                      ),
                      Text(
                        '• Never move someone with suspected neck/back injury',
                        style: TextStyle(color: AppTheme.secondaryColor), // Using accessible teal
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
        const SnackBar(
          content: Text('Please enter a question'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    }
  }
}


