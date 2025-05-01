import 'dart:developer';

import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/user_stats_response_model.dart';
import 'package:lobay/features/notifications/repository/notification_repo.dart';
import 'package:lobay/features/profile/repository/profile_repo.dart';

class UserStatController extends GetxController {
  final _notificationRepo = NotificationRepository();
  final ProfileRepo _profileRepo = ProfileRepo();
  RxBool isJoining = false.obs;
  RxBool isLoading = false.obs;
  RxString notificationId = ''.obs;
  RxString participationId = ''.obs;
  RxString requestorId = ''.obs;
  RxString activityId = ''.obs;
  RxString activity= ''.obs;
  Rx<GetUserActivityResponseModel?> userStatsResponseModel =
      Rx<GetUserActivityResponseModel?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserStats();
  }

  Future<void> fetchUserStats() async {
    isLoading.value = true;
    try {
      if (requestorId.value.isEmpty || activityId.value.isEmpty) {
        AppSnackbar.showErrorSnackBar(message: 'Invalid user or activity ID');
        return;
      }
      final response = await _profileRepo.getUserStats(
          requesterId: requestorId.value, activityId: activityId.value);

      if (response != null) {
        userStatsResponseModel.value = response;
      } else {
        AppSnackbar.showErrorSnackBar(message: 'Failed to fetch user stats');
      }
    } catch (e) {
      AppSnackbar.showErrorSnackBar(message: 'Failed to fetch user stats');
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> acceptRequest({required String notificationId, required String participationId}) async {
    try {
      final response = await _notificationRepo.acceptNotification(
        notificationId: notificationId,
        participationId:participationId,
        status: 'accepted',
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
