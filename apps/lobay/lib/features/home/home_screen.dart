import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/features/home/filter_bottomsheet_widget.dart';
import 'package:lobay/features/home/home_screen_controller.dart';
import 'package:lobay/features/home/widgets/activities.dart';
import 'package:lobay/features/profile/profile_controller.dart';
import 'package:lobay/features/profile/profile_screen.dart';
import 'package:lobay/utilities/constants/app_enums.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class HomeScreen extends StatelessWidget with DeviceSizeUtil {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final homeController = Get.put(HomeScreenController());
    final profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Obx(
            () {
              final userModel = profileController.userModel.value;
              final profileImage = userModel?.profileImage;

              return AppClickWidget(
                onTap: () async {
                  if (profileController.isLoading.value) {
                    return;
                  }
                  Get.to(() => ProfileScreen());
                },
                child: profileController.isLoading.value
                    ? CircularProgressIndicator()
                    : ClipOval(
                        child: AppImageWidget(
                          networkImage:
                              profileImage != null && profileImage.isNotEmpty,
                          imagePathOrURL: profileImage ?? '',
                        ),
                      ),
              );
            },
          ),
        ),
        title: Column(
          children: [
            Text(
              'Activities',
              style: TextUtils.getStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Home',
              style: TextUtils.getStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          AppClickWidget(
            type: ClickType.gestureDetector,
            onTap: () {
              Get.isBottomSheetOpen!
                  ? Get.back()
                  : Get.bottomSheet(
                      FilterBottomSheetWidget(),
                      isScrollControlled: true,
                      backgroundColor: AppColors.white,
                      barrierColor: AppColors.black.withAlpha(50),
                      isDismissible: true,
                    );
            },
            child: Obx(() {
              return homeController.selectedPlayerLevel.isNotEmpty ||
                      homeController.selectedActivities.isNotEmpty
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: height * 0.01),
              Text(
                'Games in your area',
                style: TextUtils.getStyle(
                  color: AppColors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              // SizedBox(height: height * 0.16),
              Expanded(
                child: SizedBox(
                  height: height * 0.7,
                  child: ActivitiesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
