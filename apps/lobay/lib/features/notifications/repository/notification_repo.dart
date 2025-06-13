import 'dart:developer' show log;

import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/accept_participation_body_model.dart';
import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/accept_participation_reponse_model.dart';
import 'package:lobay/core/network/network_models/notifications_reponse_model.dart';

class NotificationRepository {
  final _apiClient = ApiClient();

  Future<NotificationsResponse> getNotifications(
      {required String userId}) async {
    try {
      final response = await _apiClient.get(
        EndPoints.getNotifications(userId),
        retryCallback: () {},
      );
      if (response == null) {
        throw Exception('No response from server');
      }
      if (response.statusCode == 200) {
        return NotificationsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AcceptParticipationResponseModel> acceptNotification(
      {required String notificationId,
      required String status,
      required String participationId}) async {
    final AcceptParticipationBodyModel acceptParticipationBodyModel =
        AcceptParticipationBodyModel(
      notificationId: notificationId,
      status: status,
    );
    try {
      final response = await _apiClient.put(
        EndPoints.acceptParticipation(participationID: participationId),
        retryCallback: () {},
        data: acceptParticipationBodyModel.toJson(),
      );
      if (response == null) {
        throw Exception('No response from server');
      }
      log('response.data ${response.data}');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return AcceptParticipationResponseModel.fromJson(response.data);
      } else {
        AppSnackbar.showErrorSnackBar(message: response.data['error']);
        throw Exception('Failed to accept participation');
      }
    } catch (e) {
      rethrow;
    }
  }
}
