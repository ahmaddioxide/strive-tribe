// {
// "success": true,
// "message": "Join request submitted successfully",
// "participation": {
// "id": "680a55914c942c4d5555bd72",
// "activityId": "67fe4d8a6f738db08310e9fc",
// "userId": "XXXXRh76OzNtWaPcBMuWMuxjtN9WiW2",
// "status": "pending",
// "joinedAt": "2025-04-24T15:15:29.358Z",
// "userName": "Test User",
// "activityDetails": {
// "activity": "Tenis",
// "date": "25-04-2025",
// "time": "09:30 PM"
// }
// },
// "notificationId": "680a55914c942c4d5555bd78"
// }


class JoinActivityResponseModel {
  final bool success;
  final String message;
  final Participation participation;
  final String notificationId;

  JoinActivityResponseModel({
    required this.success,
    required this.message,
    required this.participation,
    required this.notificationId,
  });

  factory JoinActivityResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinActivityResponseModel(
      success: json['success'],
      message: json['message'],
      participation: Participation.fromJson(json['participation']),
      notificationId: json['notificationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'participation': participation.toJson(),
      'notificationId': notificationId,
    };
  }
}

class Participation {
  final String id;
  final String activityId;
  final String userId;
  final String status;
  final String joinedAt;
  final String userName;
  final ActivityDetails activityDetails;

  Participation({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.status,
    required this.joinedAt,
    required this.userName,
    required this.activityDetails,
  });

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'],
      activityId: json['activityId'],
      userId: json['userId'],
      status: json['status'],
      joinedAt: json['joinedAt'],
      userName: json['userName'],
      activityDetails: ActivityDetails.fromJson(json['activityDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'userId': userId,
      'status': status,
      'joinedAt': joinedAt,
      'userName': userName,
      'activityDetails': activityDetails.toJson(),
    };
  }
}

class ActivityDetails {
  final String activity;
  final String date;
  final String time;

  ActivityDetails({
    required this.activity,
    required this.date,
    required this.time,
  });

  factory ActivityDetails.fromJson(Map<String, dynamic> json) {
    return ActivityDetails(
      activity: json['activity'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'date': date,
      'time': time,
    };
  }
}