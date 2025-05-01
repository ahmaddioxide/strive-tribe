class ActivityFromGet {
  final String id;
  final String userId;
  final String name;
  final String activity;
  final String playerLevel;
  final String date;
  final String time;

  ActivityFromGet({
    required this.id,
    required this.userId,
    required this.name,
    required this.activity,
    required this.playerLevel,
    required this.date,
    required this.time,
  });

  factory ActivityFromGet.fromJson(Map<String, dynamic> json) {
    return ActivityFromGet(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      activity: json['activity'] as String,
      playerLevel: json['playerLevel'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'activity': activity,
      'playerLevel': playerLevel,
      'date': date,
      'time': time,
    };
  }
}

class GetActivitiesResponse {
  final bool success;
  final int count;
  final List<ActivityFromGet> activities;

  GetActivitiesResponse({
    required this.success,
    required this.count,
    required this.activities,
  });

  factory GetActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return GetActivitiesResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      activities: (json['activities'] as List<dynamic>)
          .map((activity) =>
              ActivityFromGet.fromJson(activity as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }
}
