class GetNearbyPlayersResponseModel {
  final bool success;
  final MainUser mainUser;
  final NearbyPlayers nearbyPlayers;

  GetNearbyPlayersResponseModel({
    required this.success,
    required this.mainUser,
    required this.nearbyPlayers,
  });

  factory GetNearbyPlayersResponseModel.fromJson(Map<String, dynamic> json) {
    return GetNearbyPlayersResponseModel(
      success: json['success'],
      mainUser: MainUser.fromJson(json['mainUser']),
      nearbyPlayers: NearbyPlayers.fromJson(json['nearbyPlayers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'mainUser': mainUser.toJson(),
      'nearbyPlayers': nearbyPlayers.toJson(),
    };
  }
}

class MainUser {
  final String userId;
  final String name;
  final String profileImage;
  final Location location;

  MainUser({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.location,
  });

  factory MainUser.fromJson(Map<String, dynamic> json) {
    return MainUser(
      userId: json['userId'],
      name: json['name'],
      profileImage: json['profileImage'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileImage': profileImage,
      'location': location.toJson(),
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

class NearbyPlayers {
  final int count;
  final List<Player> players;

  NearbyPlayers({
    required this.count,
    required this.players,
  });

  factory NearbyPlayers.fromJson(Map<String, dynamic> json) {
    return NearbyPlayers(
      count: json['count'],
      players: (json['players'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}

class Player {
  final String userId;
  final String name;
  final String profileImage;
  final int gamesPlayed;
  final List<String> activities;

  Player({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.gamesPlayed,
    required this.activities,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['userId'],
      name: json['name'],
      profileImage: json['profileImage'],
      gamesPlayed: json['gamesPlayed'],
      activities: List<String>.from(json['activities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileImage': profileImage,
      'gamesPlayed': gamesPlayed,
      'activities': activities,
    };
  }
}
