import 'dart:developer';

import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/user_stats_response_model.dart';
import 'package:lobay/features/profile/repository/profile_repo.dart';

class UserStatController extends GetxController {
  final ProfileRepo _profileRepo = ProfileRepo();
  RxBool isLoading = false.obs;
  RxString notificationId = ''.obs;
  RxString participationId = ''.obs;
  RxString userId = ''.obs;
  Rx<UserStatsResponseModel?> userStatsResponseModel =
      Rx<UserStatsResponseModel?>(null);

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
      final response = await _profileRepo.getUserStats(userId: userId.value);
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
}
