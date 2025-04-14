// {
// "user_id": "FRh76OzNtWaPcBMuWMuxjtN9WiW2",
// "selectActivity": "Football",
// "selectPlayerLevel": "intermediate",
// "selectDate": "15-08-2023",
// "selectTime": "08:30 PM",
// "notes": "Need to improve passing skills",
// "video": "data:video/mp4;base64,AAAAIGZ0eXBpc29tAAACAGlzb21pc28yYXZjMW1wNDEAAAAIZnJlZQAAAYxtZGF0AAA..."
// }

class CreateActivityBody {
  final String userId;
  final String selectActivity;
  final String selectPlayerLevel;
  final String selectDate;
  final String selectTime;
  final String notes;
  final String? video;

  CreateActivityBody({
    required this.userId,
    required this.selectActivity,
    required this.selectPlayerLevel,
    required this.selectDate,
    required this.selectTime,
    required this.notes,
    this.video,
  });

//toJson
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'selectActivity': selectActivity,
      'selectPlayerLevel': selectPlayerLevel,
      'selectDate': selectDate,
      'selectTime': selectTime,
      'notes': notes,
      'video': video,
    };
  }

  //fromJson
  factory CreateActivityBody.fromJson(Map<String, dynamic> json) {
    return CreateActivityBody(
      userId: json['user_id'],
      selectActivity: json['selectActivity'],
      selectPlayerLevel: json['selectPlayerLevel'],
      selectDate: json['selectDate'],
      selectTime: json['selectTime'],
      notes: json['notes'],
      video: json['video'],
    );
  }

}
