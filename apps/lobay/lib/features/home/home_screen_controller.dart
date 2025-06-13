import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lobay/services/shared_pref_service.dart';
import 'package:lobay/services/notification_service.dart';
import 'package:lobay/utilities/commom_models/pairs_model.dart';
import 'package:lobay/utilities/constants/app_constants.dart';

import '../../core/network/network_models/get_activities_body.dart';
import 'repository/activities_repo.dart';

class HomeScreenController extends GetxController {
  final activityRepo = ActivityRepository();

  @override
  onInit() {
    getNearbyActivities();

    super.onInit();

    // Initialize notifications if not already initialized
    final notificationService = Get.find<NotificationService>();
    if (notificationService.deviceToken == null) {
      notificationService.initialize();
    }
  }

  @override
  onReady() async {
    await getNearbyActivities();

    super.onReady();
  }

  RxList<ActivityFromGet> activitiesList = RxList<ActivityFromGet>();

  Future<void> getNearbyActivities() async {
    try {
      final currentUserId =
          await PreferencesManager.getInstance().getStringValue('userId', '');
      if (currentUserId.isEmpty) {
        return;
      }
      final GetActivitiesResponse? response =
          await activityRepo.getNearbyActivities(
        userId: currentUserId,
        activityName:
            selectedActivities.isNotEmpty ? selectedActivities.join(',') : null,
        playerLevel: selectedPlayerLevel.isNotEmpty
            ? selectedPlayerLevel.join(',')
            : null,
      );
      if (response != null) {
        activitiesList.value = response.activities;
      } else {}
    } catch (e) {
      // Handle exceptions
      if (kDebugMode) {
        print('Error fetching activities: $e');
      }
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
    getNearbyActivities();
  }
}
