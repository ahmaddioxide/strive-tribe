// {
// "notificationId": "680a55914c942c4d5555bd78",
// "status": "accepted"
// }
//

class AcceptParticipationBodyModel {
  final String notificationId;
  final String status;

  AcceptParticipationBodyModel({
    required this.notificationId,
    required this.status,
  });

  factory AcceptParticipationBodyModel.fromJson(Map<String, dynamic> json) {
    return AcceptParticipationBodyModel(
      notificationId: json['notificationId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'status': status,
    };
  }
}
