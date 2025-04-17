class GetActivityByDateTimeResponse {
  final bool success;
  final int count;
  final List<ActivityData> data;

  GetActivityByDateTimeResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetActivityByDateTimeResponse.fromJson(Map<String, dynamic> json) {
    return GetActivityByDateTimeResponse(
      success: json['success'],
      count: json['count'],
      data: (json['data'] as List)
          .map((item) => ActivityData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ActivityData {
  final User user;
  final ActivityByDateTime activity;

  ActivityData({
    required this.user,
    required this.activity,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      user: User.fromJson(json['user']),
      activity: ActivityByDateTime.fromJson(json['activity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'activity': activity.toJson(),
    };
  }
}

class User {
  final String userId;
  final String name;
  final String email;
  final String profileImage;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

class ActivityByDateTime {
  final String id;
  final String activityName;
  final String playerLevel;
  final String date;
  final String time;
  final String notes;
  final String videoUrl;
  final String createdAt;

  ActivityByDateTime({
    required this.id,
    required this.activityName,
    required this.playerLevel,
    required this.date,
    required this.time,
    required this.notes,
    required this.videoUrl,
    required this.createdAt,
  });

  factory ActivityByDateTime.fromJson(Map<String, dynamic> json) {
    return ActivityByDateTime(
      id: json['id'],
      activityName: json['Activity'],
      playerLevel: json['PlayerLevel'],
      date: json['Date'],
      time: json['Time'],
      notes: json['notes'],
      videoUrl: json['videoUrl'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Activity': activityName,
      'PlayerLevel': playerLevel,
      'Date': date,
      'Time': time,
      'notes': notes,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
    };
  }
}
