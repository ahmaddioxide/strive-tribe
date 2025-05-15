import 'dart:convert';

class RequestActivityBody {
  final String reqFrom;
  final String reqTo;
  final String activityName;
  final String activityLevel;
  final String activityDate;
  final String activityTime;
  final String? note;
  final String? video;

  RequestActivityBody({
    required this.reqFrom,
    required this.reqTo,
    required this.activityName,
    required this.activityLevel,
    required this.activityDate,
    required this.activityTime,
    this.note,
    this.video,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'reqFrom': reqFrom,
      'reqTo': reqTo,
      'activityName': activityName,
      'activityLevel': activityLevel,
      'activityDate': activityDate,
      'activityTime': activityTime,
    };

    // Only add note and video if they are not null
    if (note != null) {
      data['note'] = note;
    }
    if (video != null) {
      data['video'] = video;
    }

    return data;
  }

  factory RequestActivityBody.fromJson(Map<String, dynamic> json) {
    return RequestActivityBody(
      reqFrom: json['reqFrom'] as String,
      reqTo: json['reqTo'] as String,
      activityName: json['activityName'] as String,
      activityLevel: json['activityLevel'] as String,
      activityDate: json['activityDate'] as String,
      activityTime: json['activityTime'] as String,
      note: json['note'] as String?,
      video: json['video'] as String?,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory RequestActivityBody.fromJsonString(String jsonString) =>
      RequestActivityBody.fromJson(jsonDecode(jsonString));
}

class RequestActivityResponse {
  final bool success;
  final String message;
  final RequestActivityData data;

  RequestActivityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RequestActivityResponse.fromJson(Map<String, dynamic> json) {
    return RequestActivityResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RequestActivityData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class RequestActivityData {
  final String id;
  final String reqFrom;
  final String reqTo;
  final String activityName;
  final String activityLevel;
  final String activityDate;
  final String activityTime;
  final String note;
  final String activityId;
  final String videoUrl;
  final String createdAt;

  RequestActivityData({
    required this.id,
    required this.reqFrom,
    required this.reqTo,
    required this.activityName,
    required this.activityLevel,
    required this.activityDate,
    required this.activityTime,
    required this.note,
    required this.activityId,
    required this.videoUrl,
    required this.createdAt,
  });

  factory RequestActivityData.fromJson(Map<String, dynamic> json) {
    return RequestActivityData(
      id: json['id'] as String,
      reqFrom: json['reqFrom'] as String,
      reqTo: json['reqTo'] as String,
      activityName: json['activityName'] as String,
      activityLevel: json['activityLevel'] as String,
      activityDate: json['activityDate'] as String,
      activityTime: json['activityTime'] as String,
      note: json['note'] as String,
      activityId: json['activityId'] as String,
      videoUrl: json['videoUrl'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
