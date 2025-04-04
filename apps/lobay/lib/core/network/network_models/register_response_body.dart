// {
// "success": true,
// "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ZWZkMjk5MGI5MjI3YWU4ZDMzMjE1MCIsImlhdCI6MTc0Mzc3MDI2NSwiZXhwIjoxNzQ2MzYyMjY1fQ.449gc7JwWHjtoxBWmjxxi-qltzaqFNG_uKim-TvyImk",
// "user": {
// "id": "67efd2990b9227ae8d332150",
// "userId": "QRh76OzNtWaPcBM2uWMuxjtN9WiW2",
// "name": "Test User2",
// "email": "againtestuser2@example.com",
// "profileImage": "NULL",
// "signInWith": "google"
// }
// }

class RegisterResponseBody {
  bool success;
  String token;
  UserModel user;

  RegisterResponseBody({
    required this.success,
    required this.token,
    required this.user,
  });

  factory RegisterResponseBody.fromJson(Map<String, dynamic> json) {
    return RegisterResponseBody(
      success: json['success'],
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
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

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.signInWith,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      signInWith: json['signInWith'],
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
    };
  }
}
