import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../core/network/network_models/get_activity_by_date_time.dart';

class ActivityDetailsController extends GetxController {
  late VideoPlayerController videoController;
  final isPlaying = false.obs;
  final isInitialized = false.obs;
  GetActivityByDateTimeResponse activity = GetActivityByDateTimeResponse(
    success: false,
    activity: ActivityFromGetDateTime(
      id: '',
      activity: '',
      playerLevel: '',
      date: '',
      videoUrl: '',
      createdAt: '',
      updatedAt: '',
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
    initializeVideo();
  }

  void initializeVideo() {
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://storage.googleapis.com/strive-tribe.firebasestorage.app/activity_videos/1744913465692_txnjd7.mp4'),
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

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
