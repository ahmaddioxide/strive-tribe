import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/core/network/network_models/get_nearby_players_response_model.dart';
import 'package:lobay/features/players/players_controller.dart';
import 'package:lobay/features/players/request_activity_screen.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

import '../inbox/presentation/screens/chat_screen.dart';

class PlayerDetailsScreen extends StatefulWidget with DeviceSizeUtil {
  final Player player;

  const PlayerDetailsScreen({super.key, required this.player});

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<PlayersController>();
    controller.fetchUserDetails(widget.player.userId);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.getDeviceHeight();
    final width = widget.getDeviceWidth();
    final controller = Get.find<PlayersController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingUserDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final userDetails = controller.userDetails.value;
        if (userDetails == null) {
          return const Center(child: Text('Failed to load user details'));
        }

        return SingleChildScrollView(
          child: Column(
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
                              'Sport: ${userDetails.activities.map((e) => e.name).join(", ")}',
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
                          onPressed: () {
                            Get.to(
                              () => ChatScreen(
                                recipientId: widget.player.userId,
                                recipientName: widget.player.name,
                                recipientImage: widget.player.profileImage,
                              ),
                            );
                          },
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
                      leading: AppImageWidget(
                        imagePathOrURL: Assets.imagesActivityIcon,
                        height: 45,
                        width: 45,
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
                        '${userDetails.totalActivities} total activities',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black.withAlpha(100),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    ListTile(
                      leading: AppImageWidget(
                        imagePathOrURL: Assets.imagesCalendarRange,
                        height: 45,
                        width: 45,
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
                        '${userDetails.activitiesPerMonth.isNotEmpty ? userDetails.activitiesPerMonth.first.count : 0} activities',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black.withAlpha(100),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    ListTile(
                      leading: AppImageWidget(
                        imagePathOrURL: Assets.imagesOpponentIcon,
                        height: 45,
                        width: 45,
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
                        '${userDetails.differentOpponents} opponents',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black.withAlpha(100),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.1),
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
                            Get.to(() => RequestActivityScreen(
                                  userModel: widget.player,
                                ));
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
                            'Request Game',
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
          ),
        );
      }),
    );
  }
}
