class User {
  final String email;
  final String name;
  final String gender;
  final String dateOfBirth;
  final String phoneNumber;
  final String profileImage;
  final int gamesPlayed;
  final String placeName;
  final String countryName;
  final String state;
  final String postalCode;
  final String userId;
  final String id;
  final double latitude;
  final double longitude;

  User({
    required this.email,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.profileImage,
    required this.gamesPlayed,
    required this.placeName,
    required this.countryName,
    required this.state,
    required this.postalCode,
    required this.userId,
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      gamesPlayed: json['gamesPlayed'] ?? 0,
      placeName: json['placeName'] ?? '',
      countryName: json['countryName'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      userId: json['userId'] ?? '',
      id: json['id'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}
