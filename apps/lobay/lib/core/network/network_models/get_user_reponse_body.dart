class UserModel {
    String userId;
    String id;
    String name;
    String email;
    String profileImage;
    String placeName;
    String countryName;
    String state;
    int gamesPlayed;
    int totalActivities;
    int differentOpponents;
    List<Activity> activities;
    List<ActivitiesPerMonth> activitiesPerMonth;

    UserModel({
      required this.userId,
      required this.id,
      required this.name,
      required this.email,
      required this.profileImage,
      required this.placeName,
      required this.countryName,
      required this.state,
      required this.gamesPlayed,
      required this.totalActivities,
      required this.differentOpponents,
      required this.activities,
      required this.activitiesPerMonth,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) {
      return UserModel(
        userId: json['user']['userId'],
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        profileImage: json['user']['profileImage'],
        placeName: json['user']['placeName'],
        countryName: json['user']['countryName'],
        state: json['user']['state'],
        gamesPlayed: json['user']['gamesPlayed'],
        totalActivities: json['user']['totalActivities'],
        differentOpponents: json['user']['differentOpponents'],
        activities: (json['user']['activities'] as List<dynamic>)
            .map((e) => Activity.fromJson(e))
            .toList(),
        activitiesPerMonth: (json['user']['activitiesPerMonth'] as List<dynamic>)
            .map((e) => ActivitiesPerMonth.fromJson(e))
            .toList(),
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'userId': userId,
        'id': id,
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'placeName': placeName,
        'countryName': countryName,
        'state': state,
        'gamesPlayed': gamesPlayed,
        'totalActivities': totalActivities,
        'differentOpponents': differentOpponents,
        'activities': activities.map((e) => e.toJson()).toList(),
        'activitiesPerMonth': activitiesPerMonth.map((e) => e.toJson()).toList(),
      };
    }
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
  class ActivitiesPerMonth {
    int count;

    ActivitiesPerMonth({required this.count});

    factory ActivitiesPerMonth.fromJson(Map<String, dynamic> json) {
      return ActivitiesPerMonth(
        count: json['count'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'count': count,
      };
    }
  }