// {
// "success": true,
// "participation": {
// "id": "680a55914c942c4d5555bd72",
// "status": "accepted",
// "activityId": "67fe4d8a6f738db08310e9fc",
// "userId": "XXXXRh76OzNtWaPcBMuWMuxjtN9WiW2"
// }
// }

class AcceptParticipationResponseModel {
  final bool success;
  final Participation participation;

  AcceptParticipationResponseModel({
    required this.success,
    required this.participation,
  });

  factory AcceptParticipationResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptParticipationResponseModel(
      success: json['success'],
      participation: Participation.fromJson(json['participation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'participation': participation.toJson(),
    };
  }
}

class Participation {
  final String id;
  final String status;
  final String activityId;
  final String userId;

  Participation({
    required this.id,
    required this.status,
    required this.activityId,
    required this.userId,
  });

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'],
      status: json['status'],
      activityId: json['activityId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'activityId': activityId,
      'userId': userId,
    };
  }
}
