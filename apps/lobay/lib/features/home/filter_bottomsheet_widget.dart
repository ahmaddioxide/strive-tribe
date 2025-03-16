import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/features/home/home_screen_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class FilterBottomSheetWidget extends StatelessWidget with DeviceSizeUtil {
  const FilterBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final controller = Get.find<HomeScreenController>();
    return SizedBox(
      height: height * 0.75,
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Container(
              height: 5,
              width: width * 0.2,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextUtils.getStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.resetFilter();
                  },
                  child: Text(
                    'Clear',
                    style: TextUtils.getStyle(
                      color: AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  'Activities',
                  style: TextUtils.getStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.activities.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    return CheckboxListTile(
                      value: controller.activities[index].second.value,
                      onChanged: (value) {
                        controller.toggleActivitySelection(
                            controller.activities[index]);
                      },
                      title: Text(
                        controller.activities[index].first,
                        style: TextUtils.getStyle(
                          color: AppColors.primaryLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: AppColors.white,
                      activeColor: AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(
                        color: AppColors.grey,
                        width: 2,
                      ),
                    );
                  });
                },
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  'Player Level',
                  style: TextUtils.getStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.playerLevel.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    return CheckboxListTile(
                      value: controller.playerLevel[index].second.value,
                      onChanged: (value) {
                        controller.togglePlayerLevelSelection(
                            controller.playerLevel[index]);
                      },
                      title: Text(
                        controller.playerLevel[index].first,
                        style: TextUtils.getStyle(
                          color: AppColors.primaryLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      checkColor: AppColors.white,
                      activeColor: AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(
                        color: AppColors.grey,
                        width: 2,
                      ),
                    );
                  });
                },
              ),
            ),
            // SizedBox(height: height * 0.01),
            AppButton(
              buttonText: 'Apply',
              onPressed: () {
                log('Activities: ${controller.selectedActivities}',
                    name: 'FilterBottomSheetWidget');
                log('Player Level: ${controller.selectedPlayerLevel}',
                    name: 'FilterBottomSheetWidget');
                Get.back();
              },
            ),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }
}
