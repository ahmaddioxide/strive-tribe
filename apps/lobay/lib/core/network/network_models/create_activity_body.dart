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
  final String Activity;
  final String PlayerLevel;
  final String Date;
  final String Time;
  final String notes;
  final String? video;

  CreateActivityBody({
    required this.userId,
    required this.Activity,
    required this.PlayerLevel,
    required this.Date,
    required this.Time,
    required this.notes,
    this.video,
  });

//toJson
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'Activity': Activity,
      'PlayerLevel': PlayerLevel,
      'Date': Date,
      'Time': Time,
      'notes': notes,
      'video': video,
    };
  }

  //fromJson
  factory CreateActivityBody.fromJson(Map<String, dynamic> json) {
    return CreateActivityBody(
      userId: json['user_id'],
      Activity: json['Activity'],
      PlayerLevel: json['PlayerLevel'],
      Date: json['Date'],
      Time: json['Time'],
      notes: json['notes'],
      video: json['video'],
    );
  }
}
