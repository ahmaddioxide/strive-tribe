class LoginBodyModel {
  String userId;

  LoginBodyModel({
    required this.userId,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
    };
  }
}
