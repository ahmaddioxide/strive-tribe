import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/scheduled_activities_response_model.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart' as shared_pref;
import 'package:lobay/features/scheduled_activities/repository/scheduled_activites_repository.dart';
import 'package:lobay/services/shared_pref_service.dart';
import 'package:lobay/utilities/commom_models/pairs_model.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/core/network/network_models/get_activities_body.dart';
import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/get_user_reponse_body.dart';
import 'package:lobay/features/profile/repository/profile_repo.dart';

class ScheduledActivitiesController extends GetxController {
  final ProfileRepo _profileRepo = ProfileRepo();
  final ScheduledActivitiesRepo scheduledActivitiesRepo =
      ScheduledActivitiesRepo();
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoadingActivities = false.obs;
  final RxBool isLoadingUserDetails = false.obs;
  final Rx<ScheduledActivitiesResponseModel?> scheduledActivitiesResponseModel =
      Rx<ScheduledActivitiesResponseModel?>(null);

  @override
  void onInit() {
    getScheduledActivities();
    fetchUserDetails();
    super.onInit();
  }

  Future<void> fetchUserDetails() async {
    try {
      isLoadingUserDetails.value = true;
      final currentUserId = await shared_pref.PreferencesManager.getInstance()
          .getStringValue('userId', '');
      if (currentUserId == null || currentUserId.isEmpty) {
        isLoadingUserDetails.value = false;
        return;
      }
      user.value = await _profileRepo.getUser(userId: currentUserId);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user details: $e');
      }
      AppSnackbar.showErrorSnackBar(message: 'Failed to fetch user details');
    } finally {
      isLoadingUserDetails.value = false;
    }
  }

  Future<void> getScheduledActivities() async {
    try {
      isLoadingActivities.value = true;
      final currentUserId = await shared_pref.PreferencesManager.getInstance()
          .getStringValue('userId', '');
      if (currentUserId == null || currentUserId.isEmpty) {
        isLoadingActivities.value = false;
        return;
      }
      final ScheduledActivitiesResponseModel? response =
          await scheduledActivitiesRepo.getScheduledActivities(
              userId: currentUserId,
              activities: selectedActivities.join(','),
              playerLevels: selectedPlayerLevel.join(','));

      if (response != null) {
        scheduledActivitiesResponseModel.value = response;
      } else {
        AppSnackbar.showErrorSnackBar(
            message: 'Failed to fetch scheduled activities');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching scheduled activities: $e');
      }
      AppSnackbar.showErrorSnackBar(
          message: 'Failed to fetch scheduled activities');
    } finally {
      isLoadingActivities.value = false;
    }
  }

  final RxList<Pair<String, RxBool>> activities = <Pair<String, RxBool>>[
    Pair(AppConstants.activities[0], false.obs),
    // Pair(AppConstants.activities[1], false.obs),
    // Pair(AppConstants.activities[2], false.obs),
    // Pair(AppConstants.activities[3], false.obs),
    // Pair(AppConstants.activities[4], false.obs),
    // Pair(AppConstants.activities[5], false.obs),
  ].obs;

  final RxList<Pair<String, RxBool>> playerLevel = <Pair<String, RxBool>>[
    Pair(AppConstants.expertiseLevel[0], false.obs),
    Pair(AppConstants.expertiseLevel[1], false.obs),
    Pair(AppConstants.expertiseLevel[2], false.obs),
  ].obs;

  final RxList<String> selectedActivities = <String>[].obs;
  final RxList<String> selectedPlayerLevel = <String>[].obs;

  void toggleActivitySelection(Pair<String, RxBool> activity) {
    activity.second.value = !activity.second.value;
    if (activity.second.value) {
      selectedActivities.add(activity.first);
    } else {
      selectedActivities.remove(activity.first);
    }
  }

  void togglePlayerLevelSelection(Pair<String, RxBool> level) {
    level.second.value = !level.second.value;
    if (level.second.value) {
      selectedPlayerLevel.add(level.first);
    } else {
      selectedPlayerLevel.remove(level.first);
    }
  }

  void resetFilter() {
    for (final activity in activities) {
      activity.second.value = false;
    }
    for (final level in playerLevel) {
      level.second.value = false;
    }
    selectedActivities.clear();
    selectedPlayerLevel.clear();
    getScheduledActivities();
  }
}
