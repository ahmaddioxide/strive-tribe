// {
// "success": true,
// "user": {
// "userId": "edllpfGcvbVSNKnhHNxJhPk38wA3",
// "email": "ahmadmahmood296@gmail.com",
// "name": "Ahmad Mahmoud",
// "gender": "Male",
// "dateOfBirth": "2006-04-12",
// "location": "12312",
// "phoneNumber": "+441231231231",
// "profileImage": "https://storage.googleapis.com/strive-tribe.firebasestorage.app/strive-tribe_profile_images/1744470253906_rjzg26.jpg",
// "activities": [
// {
// "name": "Badminton",
// "expertise_level": "Beginner",
// "_id": "67fa80f31f88681cbe85fc1a"
// }
// ],
// "signInWith": "email_password",
// "isVarified": false,
// "scheduledActivities": [],
// "gamesPlayed": [],
// "id": "67fa80f31f88681cbe85fc19"
// }
// }

class GetUserResponseBody {
  bool success;
  UserModel user;

  GetUserResponseBody({
    required this.success,
    required this.user,
  });

  factory GetUserResponseBody.fromJson(Map<String, dynamic> json) {
    return GetUserResponseBody(
      success: json['success'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user': user.toJson(),
    };
  }
}

class UserModel {
  String id;
  String userId;
  String name;
  String email;
  String profileImage;
  String signInWith;
  bool isVerified;
  List<dynamic> scheduledActivities;
  List<dynamic> gamesPlayed;

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.signInWith,
    this.isVerified = false,
    this.scheduledActivities = const [],
    this.gamesPlayed = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      signInWith: json['signInWith'],
      isVerified: json['isVarified'] ?? false,
      scheduledActivities: json['scheduledActivities'] ?? [],
      gamesPlayed: json['gamesPlayed'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'signInWith': signInWith,
      'isVarified': isVerified,
      'scheduledActivities': scheduledActivities,
      'gamesPlayed': gamesPlayed,
    };
  }
}
