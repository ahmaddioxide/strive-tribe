import 'dart:developer';

import 'package:get/get.dart';
import 'package:lobay/core/network/network_models/get_activities_body.dart';
import 'package:lobay/features/create_activity/activity_repo/activity_repo.dart';
import 'package:lobay/features/home/repository/activities_repo.dart';
import 'package:video_player/video_player.dart';

import '../../core/network/network_models/get_activity_by_date_time.dart';

class ActivityDetailsController extends GetxController {
  RxBool isLoading = true.obs;
  late VideoPlayerController videoController;
  final isPlaying = false.obs;
  final isInitialized = false.obs;
  final activityRepo = ActivityRepository();
  GetActivityByDateTimeResponse activity = GetActivityByDateTimeResponse(
    success: false,
    activity: ActivityFromGetDateTime(
      id: '',
      activity: '',
      playerLevel: '',
      date: '',
      time: '',
      notes: '',
      videoUrl: '',
      createdAt: '',
    ),
    userDetails: UserDetails(
      name: '',
      countryName: '',
      state: '',
    ),
  );

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as ActivityFromGet;
    if (args != null) {
      // activity = args;
      loadActivityDetails(id: args.id);
    }

    initializeVideo();
  }

  void initializeVideo() {
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(
          activity.activity.videoUrl),
    )..initialize().then((_) {
        isInitialized.value = true;
      });
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      videoController.play();
    } else {
      videoController.pause();
    }
  }

  void loadActivityDetails({required String id}) async {
    isLoading.value = true;
    // Load activity details from the server or database
    // Update the activity variable with the fetched data
    final response = await activityRepo.getActivityById(id: id);
    if (response.success) {
      activity = response;
      log('Activity Details: ${activity.activity}');
    } else {
      log('Failed to load activity details');
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
