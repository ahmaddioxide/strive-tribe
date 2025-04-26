// {
// "success": true,
// "data": {
// "basicInfo": {
// "name": "Test Faiq another variable",
// "profileImage": "https://storage.googleapis.com/strive-tribe.firebasestorage.app/strive-tribe_profile_images/1744719014143_zgcogg.jpg",
// "location": {
// "placeName": "Beverly Hills",
// "countryName": "United States",
// "state": "California"
// }
// },
// "activities": {
// "details": [
// {
// "name": "Basketball",
// "expertiseLevel": "Intermediate"
// },
// {
// "name": "Swimming",
// "expertiseLevel": "Beginner"
// }
// ]
// },
// "opponents": 1,
// "totalActivities": 1
// }
// }

class UserStatsResponseModel {
  final bool success;
  final UserData data;

  UserStatsResponseModel({
    required this.success,
    required this.data,
  });

  factory UserStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserStatsResponseModel(
      success: json['success'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final BasicInfo basicInfo;
  final Activities activities;
  final int opponents;
  final int totalActivities;

  UserData({
    required this.basicInfo,
    required this.activities,
    required this.opponents,
    required this.totalActivities,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      basicInfo: BasicInfo.fromJson(json['basicInfo']),
      activities: Activities.fromJson(json['activities']),
      opponents: json['opponents'],
      totalActivities: json['totalActivities'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basicInfo': basicInfo.toJson(),
      'activities': activities.toJson(),
      'opponents': opponents,
      'totalActivities': totalActivities,
    };
  }
}

class BasicInfo {
  final String name;
  final String profileImage;
  final Location location;

  BasicInfo({
    required this.name,
    required this.profileImage,
    required this.location,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      name: json['name'],
      profileImage: json['profileImage'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileImage': profileImage,
      'location': location.toJson(),
    };
  }
}

class Activities {
  final List<ActivityDetail> details;

  Activities({required this.details});

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
      details: (json['details'] as List)
          .map((detail) => ActivityDetail.fromJson(detail))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}

class ActivityDetail {
  final String name;
  final String expertiseLevel;

  ActivityDetail({
    required this.name,
    required this.expertiseLevel,
  });

  factory ActivityDetail.fromJson(Map<String, dynamic> json) {
    return ActivityDetail(
      name: json['name'],
      expertiseLevel: json['expertiseLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expertiseLevel': expertiseLevel,
    };
  }
}

class Location {
  final String placeName;
  final String countryName;
  final String state;

  Location({
    required this.placeName,
    required this.countryName,
    required this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      placeName: json['placeName'],
      countryName: json['countryName'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'countryName': countryName,
      'state': state,
    };
  }
}
