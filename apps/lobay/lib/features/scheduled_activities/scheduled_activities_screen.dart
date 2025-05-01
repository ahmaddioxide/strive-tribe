import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/features/scheduled_activities/filter_bottomsheet_widget.dart';
import 'package:lobay/features/scheduled_activities/scheduled_activities_controller.dart';
import 'package:lobay/features/scheduled_activities/schedules_activities_tile.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class ScheduledActivitiesScreen extends StatelessWidget with DeviceSizeUtil {
  const ScheduledActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final controller = Get.put(ScheduledActivitiesController());
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.06),
                Row(
                  children: [
                    AppClickWidget(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_rounded,
                          color: AppColors.black),
                    ),
                    Spacer(),
                    SizedBox(width: width * 0.02),
                    Column(
                      children: [
                        Text(
                          'Scheduled Activities',
                          style: TextUtils.getStyle(
                            color: AppColors.black,
                            fontSize: width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // SizedBox(height: height * 0.01),
                        Obx(() {
                          if (controller.isLoadingUserDetails.value) {
                            return CircularProgressIndicator(
                              color: AppColors.primaryLight,
                            );
                          }
                          return Text(
                            '${controller.user.value?.placeName}, ${controller.user.value?.state}',
                            style: TextUtils.getStyle(
                              color: AppColors.grey,
                              fontSize: width * 0.04,
                            ),
                          );
                        }),
                      ],
                    ),
                    Spacer(),
                    AppClickWidget(
                      onTap: () {
                        Get.isBottomSheetOpen!
                            ? Get.back()
                            : Get.bottomSheet(
                                const ScheduledActivitiesFilterBottomSheet(),
                                isScrollControlled: true,
                                backgroundColor: AppColors.white,
                                barrierColor: AppColors.black.withAlpha(50),
                                isDismissible: true,
                              );
                      },
                      child: Obx(() {
                        return controller.selectedPlayerLevel.isNotEmpty ||
                                controller.selectedActivities.isNotEmpty
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
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingActivities.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryLight,
                    ),
                  ),
                );
              }
              if (controller.scheduledActivitiesResponseModel.value
                      ?.scheduledActivities?.isEmpty ??
                  true) {
                return const Center(
                  child: Text('No scheduled activities found'),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                itemCount:
                    controller.scheduledActivitiesResponseModel.value?.count,
                itemBuilder: (context, index) {
                  return SchedulesActivitiesTile(
                    activity: controller.scheduledActivitiesResponseModel.value!
                        .scheduledActivities![index],
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
