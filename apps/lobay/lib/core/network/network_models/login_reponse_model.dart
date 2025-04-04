// {
// "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ZWVlMDYxMDFkM2I4ZGU0OGE0Yzg5MSIsInVzZXJJZCI6IlFSaDc2T3pOdFdhUGNCTXVXTXV4anROOVdpVzIiLCJpYXQiOjE3NDM3Njc4MzAsImV4cCI6MTc0NjM1OTgzMH0.hmO5p_GwZc0yDQlO3RxByFBb6i6hYWUjD3ohTAVOlzc",
// "user": {
// "id": "67eee06101d3b8de48a4c891",
// "userId": "QRh76OzNtWaPcBMuWMuxjtN9WiW2",
// "name": "Test User2",
// "email": "againtestuser@example.com",
// "profileImage": "NULL",
// "signInWith": "google"
// }
// }

import 'package:lobay/core/network/network_models/enums/login_type.dart';

class LoginResponseModel {
  String token;
  UserModel user;

  LoginResponseModel({
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  @override
  String toString() {
    return 'UserModel{id: $id, userId: $userId, name: $name, email: $email, profileImage: $profileImage, signInWith: $signInWith}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserModel) return false;
    return id == other.id &&
        userId == other.userId &&
        name == other.name &&
        email == other.email &&
        profileImage == other.profileImage &&
        signInWith == other.signInWith;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        signInWith.hashCode;
  }
}
