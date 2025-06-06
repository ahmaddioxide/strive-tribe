import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/features/players/filter_bottomsheet_widget.dart';
import 'package:lobay/features/players/players_controller.dart';
import 'package:lobay/features/players/widgets/players_tile.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class PlayersScreen extends StatelessWidget with DeviceSizeUtil {
  final PlayersController controller = Get.put(PlayersController());

  PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: width * 0.07,
                  backgroundImage: NetworkImage(
                    controller.user.value?.profileImage ?? '',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Players',
                      style: TextUtils.getStyle(
                        color: AppColors.black,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      '${controller.user.value?.placeName}, ${controller.user.value?.state}',
                      style: TextUtils.getStyle(
                        color: AppColors.grey,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                AppClickWidget(
                  onTap: () {
                    Get.isBottomSheetOpen!
                        ? Get.back()
                        : Get.bottomSheet(
                            const PlayersFilterBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: AppColors.white,
                            barrierColor: AppColors.black.withAlpha(50),
                            isDismissible: true,
                          );
                  },
                  child: Obx(() {
                    return controller.selectedActivities.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            padding: EdgeInsets.all(height * 0.01),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.filter_list_rounded,
                              color: AppColors.white,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            padding: EdgeInsets.all(height * 0.01),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withAlpha(50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.filter_list_rounded),
                          );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Text(
              'Players in your area',
              style: TextUtils.getStyle(
                color: AppColors.grey,
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (controller.nearbyPlayersRes.value?.nearbyPlayers?.count == 0) {
              return Center(
                child: Text(
                  'No players found',
                  style: TextUtils.getStyle(
                    color: AppColors.grey,
                    fontSize: width * 0.04,
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount:
                    controller.nearbyPlayersRes.value?.nearbyPlayers?.count,
                itemBuilder: (context, index) {
                  return PlayersTile(
                    player: controller
                        .nearbyPlayersRes.value!.nearbyPlayers!.players[index],
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
