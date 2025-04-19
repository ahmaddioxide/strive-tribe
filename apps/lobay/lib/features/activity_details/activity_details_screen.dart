import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import 'package:video_player/video_player.dart';
import '../../common_widgets/app_image_widget.dart';
import 'activity_details_controller.dart';

class ActivityDetailsScreen extends StatelessWidget with DeviceSizeUtil {
  const ActivityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityDetailsController());
    final screenHeight = MediaQuery.of(context).size.height;
    final videoHeight = screenHeight / 2;
    final height = getDeviceHeight();
    final width = getDeviceWidth();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Hold tight, we are loading your activity',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight / 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(
                      () => controller.isInitialized.value
                          ? GestureDetector(
                              onTap: controller.togglePlayPause,
                              child: AspectRatio(
                                aspectRatio: controller
                                    .videoController.value.aspectRatio,
                                child: VideoPlayer(
                                  controller.videoController,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.black,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    // Centered play button
                    Obx(
                      () => controller.isPlaying.value
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: controller.togglePlayPause,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(100),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                    ),
                    // Progress bar overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(150),
                            ],
                          ),
                        ),
                        child: VideoProgressIndicator(
                          controller.videoController,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          colors: VideoProgressColors(
                            playedColor: AppColors.primaryLight,
                            bufferedColor: Colors.grey.withAlpha(150),
                            backgroundColor: Colors.white.withAlpha(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  controller.activity.userDetails.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                subtitle: Text(
                  'Sport: ${controller.activity.activity.activity}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withAlpha(100),
                  ),
                ),
                trailing: ClipOval(
                  child: AppImageWidget(
                    height: 60,
                    width: 60,
                    networkImage: controller
                        .activity.userDetails.profilePicture.isNotEmpty,
                    imagePathOrURL: controller
                            .activity.userDetails.profilePicture.isNotEmpty
                        ? controller.activity.userDetails.profilePicture
                        : Assets.imagesPlaceholderPerson,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  controller.activity.activity.notes,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withAlpha(100),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.primaryLight,
                      size: 28,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      '${controller.activity.activity.date} ${controller.activity.activity.time} ',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.primaryLight),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_city_outlined,
                      color: AppColors.primaryLight,
                      size: 28,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      '${controller.activity.userDetails.countryName}, ${controller.activity.userDetails.state}',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primaryLight,
                      size: 28,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      controller.activity.userDetails.placeName,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Player Activity',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: AppColors.primaryLight,
                  thickness: 1,
                ),
              ),
              SizedBox(height: height * 0.02),
              ListTile(
                leading: Icon(
                  Icons.speed_rounded,
                  color: AppColors.primaryLight,
                  size: 45,
                ),
                title: Text(
                  'Player Level',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  controller.activity.activity.playerLevel,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withAlpha(100),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.speed_rounded,
                  color: AppColors.primaryLight,
                  size: 45,
                ),
                title: Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '30 activities',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withAlpha(100),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryLight,
                  size: 45,
                ),
                title: Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '12 opponents',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withAlpha(100),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //rounded back button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          Get.back();
                        },
                        color: AppColors.white,
                        iconSize: 30,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button action
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width * 0.7, height * 0.07),
                        backgroundColor: AppColors.primaryLight,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Join',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        );
      }),
    );
  }
}
