class ScheduledActivitiesResponseModel {
  final bool success;
  final int count;
  final List<ScheduledActivity> scheduledActivities;

  ScheduledActivitiesResponseModel({
    required this.success,
    required this.count,
    required this.scheduledActivities,
  });

  factory ScheduledActivitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduledActivitiesResponseModel(
      success: json['success'],
      count: json['count'],
      scheduledActivities: (json['scheduledActivities'] as List)
          .map((activity) => ScheduledActivity.fromJson(activity))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'scheduledActivities': scheduledActivities.map((activity) => activity.toJson()).toList(),
    };
  }
}

class ScheduledActivity {
  final String id;
  final String? activityId;
  final String activity;
  final String activityCreatorName;
  final String playerLevel;
  final String date;
  final String time;
  final String status;

  ScheduledActivity({
    required this.id,
     this.activityId,
    required this.activity,
    required this.activityCreatorName,
    required this.playerLevel,
    required this.date,
    required this.time,
    required this.status,
  });

  factory ScheduledActivity.fromJson(Map<String, dynamic> json) {
    return ScheduledActivity(
      id: json['id'],
      activityId: json['activityId'] ,
      activity: json['activity'],
      activityCreatorName: json['activityCreatorName'],
      playerLevel: json['playerLevel'] ??'',
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId ,
      'activity': activity,
      'activityCreatorName': activityCreatorName,
      'playerLevel': playerLevel,
      'date': date,
      'time': time,
      'status': status,
    };
  }
}