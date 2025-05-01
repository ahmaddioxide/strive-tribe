// {
// "success": true,
// "notifications": [
// {
// "_id": "680a55914c942c4d5555bd78",
// "userId": "LRh76OzNtWaPcBMuWMuxjtN9WiW2",
// "title": "Test User is requesting to play",
// "message": "Tenis on 25-04-2025 at 09:30 PM",
// "profileImage": "https://storage.googleapis.com/strive-tribe.firebasestorage.app/strive-tribe_profile_images/1745066998720_ev7era.jpg",
// "activityId": "67fe4d8a6f738db08310e9fc",
// "requesterId": "XXXXRh76OzNtWaPcBMuWMuxjtN9WiW2",
// "activityDate": "25-04-2025",
// "activityTime": "09:30 PM",
// "read": false,
// "status": "accepted",
// "createdAt": "2025-04-24T15:15:29.423Z",
// "updatedAt": "2025-04-24T15:19:05.010Z",
// "__v": 0
// }
// ]
// }

class NotificationsResponse {
  final bool success;
  final List<NotificationModel> notifications;

  NotificationsResponse({
    required this.success,
    required this.notifications,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      success: json['success'],
      notifications: (json['notifications'] as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'notifications':
          notifications.map((notification) => notification.toJson()).toList(),
    };
  }
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String profileImage;
  final String activityId;
  final String requesterId;
  final String activityDate;
  final String activityTime;
  final String participationId;
  final bool read;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int version;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.profileImage,
    required this.activityId,
    required this.participationId,
    required this.requesterId,
    required this.activityDate,
    required this.activityTime,
    required this.read,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      participationId: json['participationId'],
      profileImage: json['profileImage'],
      activityId: json['activityId'],
      requesterId: json['requesterId'],
      activityDate: json['activityDate'],
      activityTime: json['activityTime'],
      read: json['read'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'profileImage': profileImage,
      'participationId': participationId,
      'activityId': activityId,
      'requesterId': requesterId,
      'activityDate': activityDate,
      'activityTime': activityTime,
      'read': read,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }
}
