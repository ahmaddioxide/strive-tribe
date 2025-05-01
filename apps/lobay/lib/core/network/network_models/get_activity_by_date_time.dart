// ///{
//     "success": true,
//     "data": {
//         "activity": {
//             "_id": "67fe4d5d6f738db08310e9fa",
//             "Activity": "Football",
//             "PlayerLevel": "Intermediate",
//             "Date": "15-08-2023",
//             "Time": "08:30 PM",
//             "notes": "Need to improve passing skills",
//             "videoUrl": "https://storage.googleapis.com/strive-tribe.firebasestorage.app/activity_videos/1744719194873_if0mo3.mp4",
//             "createdAt": "2025-04-15T12:13:17.039Z"
//         },
//         "userDetails": {
//             "name": "Test Faiq another variable",
//             "countryName": "United States",
//             "state": "California"
//         }
//     }
// }

class GetActivityByDateTimeResponse {
  final bool success;
  final ActivityFromGetDateTime activity;
  final UserDetails userDetails;

  GetActivityByDateTimeResponse({
    required this.success,
    required this.activity,
    required this.userDetails,
  });

  factory GetActivityByDateTimeResponse.fromJson(Map<String, dynamic> json) {
    return GetActivityByDateTimeResponse(
      success: json['success'] as bool,
      activity: ActivityFromGetDateTime.fromJson(json['data']['activity']),
      userDetails: UserDetails.fromJson(json['data']['userDetails']),
    );
  }
}

class ActivityFromGetDateTime {
  final String id;
  final String activity;
  final String playerLevel;
  final String date;
  final String time;
  final String videoUrl;
  final String createdAt;
  final String notes;

  ActivityFromGetDateTime({
    required this.id,
    required this.activity,
    required this.playerLevel,
    required this.date,
    required this.time,
    required this.videoUrl,
    required this.createdAt,
    this.notes = '',
  });

  factory ActivityFromGetDateTime.fromJson(Map<String, dynamic> json) {
    return ActivityFromGetDateTime(
      id: json['_id'] as String,
      activity: json['Activity'] as String,
      playerLevel: json['PlayerLevel'] as String,
      date: json['Date'] as String,
      time: json['Time'] as String,
      notes: json['notes'] as String,
      videoUrl: json['videoUrl'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

class UserDetails {
  final String name;
  final String countryName;
  final String state;
  final String placeName;
  final String profilePicture;


  UserDetails({
    required this.name,
    required this.countryName,
    required this.state,
    this.placeName = '',
    this.profilePicture = '',

  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json['name'] as String,
      countryName: json['countryName'] as String,
      state: json['state'] as String,
      placeName: json['placeName'] as String,
      profilePicture: json['profilePicture'] as String,
    );
  }
}

// class Activity {
//   final String id;
//   final String activity;
//   final String playerLevel;
//   final String date;

//   Activity({
//     required this.id,
//     required this.activity,
//     required this.playerLevel,
//     required this.date,
//   });

//   factory Activity.fromJson(Map<String, dynamic> json) {
//     return Activity(
//       id: json['_id'] as String,
//       activity: json['Activity'] as String,
//       playerLevel: json['PlayerLevel'] as String,
//       date: json['Date'] as String,
//     );
//   }
// }
