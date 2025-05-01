class UserModel {
  String userId;
  String name;
  String email;
  String profileImage;
  String phoneNumber;
  String signInWith;
  String dateOfBirth;
  bool isVerified;
  String gender;
  String postalCode;
  String placeName;
  String countryName;
  String longitude;
  String latitude;
  String deviceToken;
  String state;
  List<Activity> activities;
  List<ScheduledActivity> scheduledActivities;
  int? gamesPlayed;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.phoneNumber,
    required this.signInWith,
    required this.gender,
    required this.dateOfBirth,
    required this.postalCode,
    required this.placeName,
    required this.countryName,
    required this.longitude,
    required this.latitude,
    required this.deviceToken,
    required this.state,
    this.isVerified = false,
    this.activities = const [],
    this.scheduledActivities = const [],
    this.gamesPlayed = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user']['userId'],
      name: json['user']['name'],
      email: json['user']['email'],
      profileImage: json['user']['profileImage'],
      phoneNumber: json['user']['phoneNumber'],
      signInWith: json['user']['signInWith'],
      gender: json['user']['gender'],
      isVerified: json['user']['isVerified'] ?? false,
      dateOfBirth: json['user']['dateOfBirth'],
      postalCode: json['user']['postalCode'] ?? '',
      placeName: json['user']['placeName'] ?? '',
      countryName: json['user']['countryName'] ?? '',
      longitude: json['user']['longitude'] ?? '',
      latitude: json['user']['latitude'] ?? '',
      deviceToken: json['user']['deviceToken'] ?? '',
      state: json['user']['state'] ?? '',
      activities: (json['user']['activities'] as List<dynamic>?)
              ?.map((e) => Activity.fromJson(e))
              .toList() ??
          [],
      scheduledActivities: (json['user']['scheduledActivities'] as List<dynamic>?)
              ?.map((e) => ScheduledActivity.fromJson(e))
              .toList() ??
          [],
      gamesPlayed: json['user']['gamesPlayed'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'userId': userId,
  //     'name': name,
  //     'email': email,
  //     'profileImage': profileImage,
  //     'phoneNumber': phoneNumber,
  //     'signInWith': signInWith,
  //     'isVerified': isVerified,
  //     'dateOfBirth': dateOfBirth,
  //     'postalCode': postalCode,
  //     'placeName': placeName,
  //     'countryName': countryName,
  //     'longitude': longitude,
  //     'latitude': latitude,
  //     'deviceToken': deviceToken,
  //     'state': state,
  //     'gender': gender,
  //     'activities': activities.map((e) => e.toJson()).toList(),
  //     'scheduledActivities':
  //         scheduledActivities.map((e) => e.toJson()).toList(),
  //     'gamesPlayed': gamesPlayed,
  //   };
  // }
}

class Activity {
  String name;
  String expertiseLevel;
  String id;

  Activity({
    required this.name,
    required this.expertiseLevel,
    required this.id,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      expertiseLevel: json['expertise_level'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expertise_level': expertiseLevel,
      '_id': id,
    };
  }
}

class ScheduledActivity {
  String activity;
  String partnerName;
  String date;
  String time;
  String id;

  ScheduledActivity({
    required this.activity,
    required this.partnerName,
    required this.date,
    required this.time,
    required this.id,
  });

  factory ScheduledActivity.fromJson(Map<String, dynamic> json) {
    return ScheduledActivity(
      activity: json['activity'],
      partnerName: json['partnerName'],
      date: json['date'],
      time: json['time'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'partnerName': partnerName,
      'date': date,
      'time': time,
      '_id': id,
    };
  }
}