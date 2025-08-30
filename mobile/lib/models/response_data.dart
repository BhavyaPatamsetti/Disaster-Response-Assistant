class ResponseData {
  final String answer;
  final List<SourceData> sources;
  final double confidence;
  final double processingTime;
  final bool offline;

  ResponseData({
    required this.answer,
    required this.sources,
    required this.confidence,
    required this.processingTime,
    required this.offline,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      answer: json['answer'] ?? '',
      sources: (json['sources'] as List<dynamic>?)
          ?.map((source) => SourceData.fromJson(source))
          .toList() ?? [],
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      processingTime: (json['processing_time'] ?? 0.0).toDouble(),
      offline: json['offline'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'sources': sources.map((source) => source.toJson()).toList(),
      'confidence': confidence,
      'processing_time': processingTime,
      'offline': offline,
    };
  }

  // Get confidence level description
  String get confidenceLevel {
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.6) return 'Medium';
    if (confidence >= 0.4) return 'Low';
    return 'Very Low';
  }

  // Get confidence color
  int get confidenceColor {
    if (confidence >= 0.8) return 0xFF4CAF50; // Green
    if (confidence >= 0.6) return 0xFFFF9800; // Orange
    if (confidence >= 0.4) return 0xFFFF5722; // Red
    return 0xFFE91E63; // Pink
  }

  // Check if response has sources
  bool get hasSources => sources.isNotEmpty;

  // Get top source
  SourceData? get topSource => sources.isNotEmpty ? sources.first : null;
}

class SourceData {
  final String source;
  final String filename;
  final double similarity;
  final String preview;

  SourceData({
    required this.source,
    required this.filename,
    required this.similarity,
    required this.preview,
  });

  factory SourceData.fromJson(Map<String, dynamic> json) {
    return SourceData(
      source: json['source'] ?? '',
      filename: json['filename'] ?? '',
      similarity: (json['similarity'] ?? 0.0).toDouble(),
      preview: json['preview'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'filename': filename,
      'similarity': similarity,
      'preview': preview,
    };
  }

  // Get similarity percentage
  String get similarityPercentage => '${(similarity * 100).toStringAsFixed(1)}%';

  // Get similarity level
  String get similarityLevel {
    if (similarity >= 0.8) return 'Very High';
    if (similarity >= 0.6) return 'High';
    if (similarity >= 0.4) return 'Medium';
    if (similarity >= 0.2) return 'Low';
    return 'Very Low';
  }

  // Get similarity color
  int get similarityColor {
    if (similarity >= 0.8) return 0xFF4CAF50; // Green
    if (similarity >= 0.6) return 0xFF8BC34A; // Light Green
    if (similarity >= 0.4) return 0xFFFF9800; // Orange
    if (similarity >= 0.2) return 0xFFFF5722; // Red
    return 0xFFE91E63; // Pink
  }
}

class PromptTemplate {
  final String key;
  final String question;
  final String category;
  final String icon;

  PromptTemplate({
    required this.key,
    required this.question,
    required this.category,
    required this.icon,
  });

  factory PromptTemplate.fromJson(Map<String, dynamic> json) {
    return PromptTemplate(
      key: json['key'] ?? '',
      question: json['question'] ?? '',
      category: json['category'] ?? '',
      icon: json['icon'] ?? '❓',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'question': question,
      'category': category,
      'icon': icon,
    };
  }
}

// Predefined prompt templates
class PromptTemplates {
  static final List<PromptTemplate> firstAid = [
    PromptTemplate(
      key: 'bleeding',
      question: 'Person has heavy bleeding from [location]—what do I do first?',
      category: 'First Aid',
      icon: '🩸',
    ),
    PromptTemplate(
      key: 'cpr',
      question: 'Someone is unconscious and not breathing—how do I perform CPR?',
      category: 'First Aid',
      icon: '💓',
    ),
    PromptTemplate(
      key: 'burns',
      question: 'Person has [degree] burns on [location]—immediate treatment?',
      category: 'First Aid',
      icon: '🔥',
    ),
    PromptTemplate(
      key: 'fractures',
      question: 'Person has a suspected broken [bone]—what should I do?',
      category: 'First Aid',
      icon: '🦴',
    ),
    PromptTemplate(
      key: 'choking',
      question: 'Someone is choking and can\'t speak—how do I help?',
      category: 'First Aid',
      icon: '😵',
    ),
    PromptTemplate(
      key: 'shock',
      question: 'Person shows signs of shock after injury—what do I do?',
      category: 'First Aid',
      icon: '😰',
    ),
  ];

  static final List<PromptTemplate> survival = [
    PromptTemplate(
      key: 'water',
      question: 'How do I make drinking water safe after [disaster]?',
      category: 'Survival',
      icon: '💧',
    ),
    PromptTemplate(
      key: 'shelter',
      question: 'How do I build emergency shelter in [environment]?',
      category: 'Survival',
      icon: '🏠',
    ),
    PromptTemplate(
      key: 'fire',
      question: 'How do I start a fire safely in [conditions]?',
      category: 'Survival',
      icon: '🔥',
    ),
    PromptTemplate(
      key: 'food',
      question: 'What food is safe to eat in emergency situations?',
      category: 'Survival',
      icon: '🍎',
    ),
    PromptTemplate(
      key: 'sanitation',
      question: 'How do I maintain hygiene without running water?',
      category: 'Survival',
      icon: '🧼',
    ),
    PromptTemplate(
      key: 'navigation',
      question: 'How do I navigate without GPS or compass?',
      category: 'Survival',
      icon: '🧭',
    ),
  ];

  static final List<PromptTemplate> communications = [
    PromptTemplate(
      key: 'checkin',
      question: 'Generate an SMS check-in message for family',
      category: 'Communications',
      icon: '📱',
    ),
    PromptTemplate(
      key: 'emergency',
      question: 'Create emergency contact message with location',
      category: 'Communications',
      icon: '🚨',
    ),
    PromptTemplate(
      key: 'status',
      question: 'Template for reporting current situation',
      category: 'Communications',
      icon: '📊',
    ),
    PromptTemplate(
      key: 'help',
      question: 'Message requesting specific assistance',
      category: 'Communications',
      icon: '🆘',
    ),
    PromptTemplate(
      key: 'evacuation',
      question: 'Notification about evacuation plans',
      category: 'Communications',
      icon: '🚪',
    ),
  ];

  static List<PromptTemplate> getByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'first aid':
        return firstAid;
      case 'survival':
        return survival;
      case 'communications':
        return communications;
      default:
        return [];
    }
  }

  static List<PromptTemplate> getAll() {
    return [...firstAid, ...survival, ...communications];
  }
}
