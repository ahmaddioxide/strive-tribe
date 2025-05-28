import 'dart:convert';

class AllChatsResponse {
  final bool success;
  final List<Conversation> conversations;

  AllChatsResponse({
    required this.success,
    required this.conversations,
  });

  factory AllChatsResponse.fromJson(Map<String, dynamic> json) {
    return AllChatsResponse(
      success: json['success'] as bool,
      conversations: (json['conversations'] as List)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'conversations': conversations.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory AllChatsResponse.fromJsonString(String jsonString) =>
      AllChatsResponse.fromJson(jsonDecode(jsonString));
}

class Conversation {
  final String id;
  final String lastMessage;
  final String lastMessageTimestamp;
  final int unreadCount;
  final Recipient recipient;

  Conversation({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    required this.recipient,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp: json['lastMessageTimestamp'] as String,
      unreadCount: json['unreadCount'] as int,
      recipient: Recipient.fromJson(json['recipient'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
      'unreadCount': unreadCount,
      'recipient': recipient.toJson(),
    };
  }
}

class Recipient {
  final String id;
  final String userId;
  final String name;
  final String profileImage;

  Recipient({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileImage,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'name': name,
      'profileImage': profileImage,
    };
  }
}
