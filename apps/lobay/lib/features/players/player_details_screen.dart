import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/core/network/network_models/get_nearby_players_response_model.dart';
import 'package:lobay/features/players/players_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class PlayerDetailsScreen extends StatelessWidget with DeviceSizeUtil {
  final Player player;

  const PlayerDetailsScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final controller = Get.find<PlayersController>();

    // Fetch user details when screen is opened
    controller.fetchUserDetails(player.userId);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final userDetails = controller.userDetails.value;
        if (userDetails == null) {
          return const Center(child: Text('Failed to load user details'));
        }

        return Column(
          children: [
            Image.network(
              height: height * 0.3,
              width: width,
              userDetails.profileImage,
              fit: BoxFit.cover,
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userDetails.name,
                            style: TextStyle(
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            'Sport: ${userDetails.activities.join(", ")}',
                            style: TextUtils.getStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.message_rounded,
                          color: AppColors.primaryLight,
                          size: height * 0.04,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primaryLight,
                        size: height * 0.03,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        '${userDetails.placeName}, ${userDetails.state}',
                        style: TextUtils.getStyle(
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Player Activities',
                    style: TextUtils.getStyle(
                      fontSize: height * 0.022,
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: AppColors.primaryLight,
                    thickness: 1,
                  ),
                  SizedBox(height: height * 0.01),
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
                      userDetails.expertiseLevel,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black.withAlpha(100),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  ListTile(
                    leading: Icon(
                      Icons.sports_baseball_rounded,
                      color: AppColors.primaryLight,
                      size: 45,
                    ),
                    title: Text(
                      'Activities',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${userDetails.activities.length} total activities',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black.withAlpha(100),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryLight,
                      size: 45,
                    ),
                    title: Text(
                      'Activities in the last 30 days',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${userDetails.gamesPlayed} activities',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black.withAlpha(100),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryLight,
                      size: 45,
                    ),
                    title: Text(
                      'Opponents',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${userDetails.gamesPlayed} opponents',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black.withAlpha(100),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                          // TODO: Implement request to play functionality
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
                          'Request to Play',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
