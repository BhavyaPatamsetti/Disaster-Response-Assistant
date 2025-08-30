class GroupMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;

  GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'groupId': groupId,
    'senderId': senderId,
    'senderName': senderName,
    'content': content,
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
    'metadata': metadata,
  };

  factory GroupMessage.fromJson(Map<String, dynamic> json) => GroupMessage(
    id: json['id'],
    groupId: json['groupId'],
    senderId: json['senderId'],
    senderName: json['senderName'],
    content: json['content'],
    type: MessageType.values.firstWhere((e) => e.name == json['type']),
    timestamp: DateTime.parse(json['timestamp']),
    status: MessageStatus.values.firstWhere((e) => e.name == json['status']),
    metadata: json['metadata'],
  );
}

class MessageGroup {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;
  final GroupType type;
  final bool isActive;

  MessageGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
    required this.type,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'memberIds': memberIds,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'type': type.name,
    'isActive': isActive,
  };

  factory MessageGroup.fromJson(Map<String, dynamic> json) => MessageGroup(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    memberIds: List<String>.from(json['memberIds']),
    createdBy: json['createdBy'],
    createdAt: DateTime.parse(json['createdAt']),
    type: GroupType.values.firstWhere((e) => e.name == json['type']),
    isActive: json['isActive'] ?? true,
  );
}

enum MessageType {
  text,
  location,
  status,
  emergency,
  image,
  voice
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed
}

enum GroupType {
  family,
  team,
  emergency,
  neighborhood,
  custom
}