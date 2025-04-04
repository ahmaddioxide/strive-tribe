// {
// "user_id": "QRh76OzNtWaPcBMuWMuxjtN9WiW2",
// "email": "againtestuser@example.com",
// "name": "Test User2",
// "gender": "male",
// "date_of_birth": "2000-01-01",
// "location": "Test City",
// "phone": "+1234567890",
// "signInWith": "google",
// "activities": [
// {
// "name": "Basketball",
// "expertise_level": "Intermediate"
// },
// {
// "name": "Swimming",
// "expertise_level": "Beginner"
// }
// ],
// "profile_image": "/9j/4AAQSkZJRgABAQEAAAAAAAD/"
// }

class RegisterBodyModel {
  String userId;
  String email;
  String name;
  String gender;
  String dateOfBirth;
  String location;
  String phone;
  String signInWith;
  List<Activity> activities;
  String profileImage;

  //constructor
  RegisterBodyModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.location,
    required this.phone,
    required this.signInWith,
    required this.activities,
    required this.profileImage,
  });

  //toJson

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'location': location,
      'phone': phone,
      'signInWith': signInWith,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'profile_image': profileImage,
    };
  }

  //fromJson
  factory RegisterBodyModel.fromJson(Map<String, dynamic> json) {
    return RegisterBodyModel(
      userId: json['user_id'],
      email: json['email'],
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      location: json['location'],
      phone: json['phone'],
      signInWith: json['signInWith'],
      activities: (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toList(),
      profileImage: json['profile_image'],
    );
  }
}

class Activity {
  String name;
  String expertiseLevel;

  Activity({
    required this.name,
    required this.expertiseLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expertise_level': expertiseLevel,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      expertiseLevel: json['expertise_level'],
    );
  }
}
