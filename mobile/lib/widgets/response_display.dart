import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disaster_response_assistant/providers/app_state.dart';
import 'package:disaster_response_assistant/models/response_data.dart';
import 'package:disaster_response_assistant/main.dart'; // Import AppTheme
import 'package:flutter/services.dart'; // For clipboard
import 'package:share_plus/share_plus.dart'; // For native sharing

class ResponseDisplay extends StatefulWidget {
  const ResponseDisplay({super.key});

  @override
  State<ResponseDisplay> createState() => _ResponseDisplayState();
}

class _ResponseDisplayState extends State<ResponseDisplay> {
  bool _isSummarized = false;
  String? _summarizedText;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final response = appState.currentResponse;
        if (response == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Response content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary toggle section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: AppTheme.accentColor,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Quick Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isSummarized 
                                ? 'Showing key points for quick understanding'
                                : 'Get the main points in seconds - perfect when time is limited',
                            style: TextStyle(
                              color: AppTheme.accentColor.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isSummarized 
                                      ? () => setState(() => _isSummarized = false)
                                      : () => _generateSummary(response.answer),
                                  icon: Icon(_isSummarized ? Icons.article : Icons.summarize),
                                  label: Text(_isSummarized ? 'Show Full Response' : 'Summarize'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isSummarized 
                                        ? AppTheme.secondaryColor 
                                        : AppTheme.accentColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Answer text (full or summarized)
                    if (_isSummarized && _summarizedText != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: AppTheme.successColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Key Points Summary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _summarizedText!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        response.answer,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Confidence indicator
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confidence Level',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.successColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${((response.confidence ?? 0.0) * 100).clamp(0.0, 100.0).toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: (response.confidence ?? 0.0).clamp(0.0, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.successColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Processing time
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: AppTheme.secondaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Processed in ${(response.processingTime ?? 0.0).clamp(0.0, 999.99).toStringAsFixed(2)}s',
                            style: const TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sources section
                    if (response.hasSources) ...[
                      Text(
                        '📚 Sources & References',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...response.sources.map((source) => _buildSourceCard(source)),
                      const SizedBox(height: 16),
                    ],

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _copyResponse(context, _isSummarized && _summarizedText != null ? _summarizedText! : response.answer),
                            icon: const Icon(Icons.copy),
                            label: Text(_isSummarized ? 'Copy Summary' : 'Copy Response'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _shareResponse(context, _isSummarized && _summarizedText != null ? _summarizedText! : response.answer),
                            icon: const Icon(Icons.share),
                            label: Text(_isSummarized ? 'Share Summary' : 'Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _generateSummary(String fullText) {
    // Simple summarization logic - extract key points
    final lines = fullText.split('\n');
    final summaryPoints = <String>[];
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isNotEmpty) {
        // Look for numbered points, bullet points, or key phrases
        if (trimmedLine.startsWith(RegExp(r'^\d+\.')) || // Numbered points
            trimmedLine.startsWith('•') || // Bullet points
            trimmedLine.startsWith('-') || // Dash points
            trimmedLine.contains('DO NOT') || // Important warnings
            trimmedLine.contains('Call emergency') || // Emergency actions
            trimmedLine.contains('immediate') || // Immediate actions
            trimmedLine.contains('first') || // First steps
            trimmedLine.contains('important') || // Important info
            trimmedLine.contains('key') || // Key information
            trimmedLine.contains('critical') || // Critical info
            trimmedLine.contains('urgent') || // Urgent actions
            trimmedLine.contains('emergency')) { // Emergency info
          summaryPoints.add(trimmedLine);
        }
      }
    }
    
    // If we found key points, use them; otherwise create a simple summary
    if (summaryPoints.isNotEmpty) {
      _summarizedText = summaryPoints.take(8).join('\n\n'); // Take first 8 key points
    } else {
      // Create a simple summary by taking first few sentences
      final sentences = fullText.split('.');
      _summarizedText = '${sentences.take(3).join('.')}.';
    }
    
    setState(() {
      _isSummarized = true;
    });
  }

  Widget _buildSourceCard(SourceData source) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          source.source,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Similarity: ${source.similarityPercentage}',
          style: const TextStyle(
            color: AppTheme.secondaryColor, // Using accessible teal for similarity
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File: ${source.filename}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preview:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  source.preview,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Real copy functionality - copies to device clipboard
  void _copyResponse(BuildContext context, String response) async {
    print('Copy function called with response length: ${response.length}'); // Debug print
    
    try {
      await Clipboard.setData(ClipboardData(text: response));
      print('Text copied to clipboard successfully'); // Debug print
      
      if (mounted) {
        print('Showing success SnackBar'); // Debug print
        
        // Show SnackBar in the parent context (above the modal)
        final parentContext = Navigator.of(context).context;
        
        // Show a more prominent success message
        ScaffoldMessenger.of(parentContext).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isSummarized ? 'Summary Copied!' : 'Response Copied!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isSummarized 
                              ? 'Summary is now in your clipboard'
                              : 'Response is now in your clipboard',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 6), // Increased duration for testing
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
              },
            ),
          ),
        );
        
        print('SnackBar should now be visible'); // Debug print
      }
    } catch (e) {
      print('Error copying to clipboard: $e'); // Debug print
      
      if (mounted) {
        final parentContext = Navigator.of(context).context;
        
        ScaffoldMessenger.of(parentContext).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Failed to copy to clipboard: $e',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 5), // Increased duration for testing
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    }
  }

  // Real share functionality - opens native share dialog
  void _shareResponse(BuildContext context, String response) async {
    try {
      // Create a formatted share text
      final shareText = _isSummarized 
          ? 'Disaster Response Summary:\n\n$response\n\n---\nShared from Disaster Response Assistant App'
          : 'Disaster Response Guidance:\n\n$response\n\n---\nShared from Disaster Response Assistant App';

      // Use native share functionality
      await Share.share(
        shareText,
        subject: _isSummarized 
            ? 'Disaster Response Summary' 
            : 'Disaster Response Guidance',
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
      );

      if (mounted) {
        final parentContext = Navigator.of(context).context;
        
        ScaffoldMessenger.of(parentContext).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Share Dialog Opened!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Choose how you want to share the ${_isSummarized ? 'summary' : 'response'}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: AppTheme.secondaryColor,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Failed to open share dialog: $e',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}
