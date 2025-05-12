import 'dart:convert';

class RequestActivityBody {
  final String reqFrom;
  final String reqTo;
  final String activityId;
  final String activityName;
  final String activityLevel;
  final String activityDate;
  final String activityTime;
  final String note;
  final String video;

  RequestActivityBody({
    required this.reqFrom,
    required this.reqTo,
    required this.activityId,
    required this.activityName,
    required this.activityLevel,
    required this.activityDate,
    required this.activityTime,
    required this.note,
    required this.video,
  });

  Map<String, dynamic> toJson() {
    return {
      'reqFrom': reqFrom,
      'reqTo': reqTo,
      'activityId': activityId,
      'activityName': activityName,
      'activityLevel': activityLevel,
      'activityDate': activityDate,
      'activityTime': activityTime,
      'note': note,
      'video': video,
    };
  }

  factory RequestActivityBody.fromJson(Map<String, dynamic> json) {
    return RequestActivityBody(
      reqFrom: json['reqFrom'] as String,
      reqTo: json['reqTo'] as String,
      activityId: json['activityId'] as String,
      activityName: json['activityName'] as String,
      activityLevel: json['activityLevel'] as String,
      activityDate: json['activityDate'] as String,
      activityTime: json['activityTime'] as String,
      note: json['note'] as String,
      video: json['video'] as String,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory RequestActivityBody.fromJsonString(String jsonString) =>
      RequestActivityBody.fromJson(jsonDecode(jsonString));
}
