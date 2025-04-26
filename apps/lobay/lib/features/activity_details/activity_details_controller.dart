import 'dart:developer';

import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/get_activities_body.dart';
import 'package:lobay/features/home/repository/activities_repo.dart';
import 'package:video_player/video_player.dart';

import '../../core/network/network_models/get_activity_by_date_time.dart';
import '../../services/shared_pref_service.dart';

class ActivityDetailsController extends GetxController {
  RxBool isLoading = true.obs;
  late VideoPlayerController videoController;
  final isPlaying = false.obs;
  final RxBool isJoining = false.obs;
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
    final args = Get.arguments as ActivityFromGet?;
    if (args != null) {
      // activity = args;
      loadActivityDetails(id: args.id);
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void initializeVideo() {
    log('Initializing video player with URL: ${activity.activity.videoUrl}');
    if (activity.activity.videoUrl.isEmpty) {
      log('Video URL is empty');
      return;
    }

    try {
      final uri = Uri.parse(activity.activity.videoUrl);
      if (!uri.hasScheme || !uri.hasAuthority) {
        log('Invalid video URL format: ${activity.activity.videoUrl}');
        return;
      }

      log('Video URL parsed successfully: ${uri.toString()}');
      log('Video URL scheme: ${uri.scheme}');
      log('Video URL host: ${uri.host}');
      log('Video URL path: ${uri.path}');

      videoController = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: {
          'Accept': '*/*',
          'User-Agent': 'Mozilla/5.0',
        },
      )..initialize().then((_) {
          isInitialized.value = true;
          log('Video player initialized successfully');
        }).catchError((error, stackTrace) {
          log('Error initializing video player: $error');
          log('Stack trace: $stackTrace');
          isInitialized.value = false;
        });
    } catch (e, stackTrace) {
      log('Exception while initializing video player: $e');
      log('Stack trace: $stackTrace');
      isInitialized.value = false;
    }
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
    try {
      final response = await activityRepo.getActivityById(id: id);
      if (response.success) {
        activity = response;
        log('Activity loaded successfully. Video URL: ${activity.activity.videoUrl}');
        if (activity.activity.videoUrl.isNotEmpty) {
          // Add a small delay to ensure the UI is ready
          await Future.delayed(const Duration(milliseconds: 100));
          initializeVideo();
        } else {
          log('No video URL found for this activity');
        }
      } else {
        log('Failed to load activity details');
      }
    } catch (e, stackTrace) {
      log('Error loading activity details: $e');
      log('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> joinActivity() async {
    isJoining.value = true;
    final userId =
        await PreferencesManager.getInstance().getStringValue('userId', '');
    final activityId = activity.activity.id;
    if (userId == null || userId.isEmpty) {
      log('User ID is null or empty');
      return false;
    }
    if (activityId == null || activityId.isEmpty) {
      log('Activity ID is null or empty');
      return false;
    }

    try {
      final response = await activityRepo.joinActivity(
        userId: userId,
        activityId: activityId,
      );
      if (response.success) {
        AppSnackbar.showSuccessSnackBar(message: response.message);
        return true;
      } else {
        log('Failed to join the activity');
        AppSnackbar.showErrorSnackBar(message: response.message);
        return false;
      }
    } catch (e) {
      log('Error joining the activity: $e');
      AppSnackbar.showErrorSnackBar(message: e.toString());
      return false;
    } finally {
      isJoining.value = false;
    }
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
