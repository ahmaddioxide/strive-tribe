import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/core/network/network_models/scheduled_activities_response_model.dart';
import 'package:lobay/features/scheduled_activities/scheduled_activities_controller.dart';
import 'package:lobay/utilities/app_utils/app_utils.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SchedulesActivitiesTile extends StatelessWidget with DeviceSizeUtil {
  final ScheduledActivity activity;

  const SchedulesActivitiesTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final controller = Get.find<ScheduledActivitiesController>();
    return Obx(() {
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

      return Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.005),
        child: Row(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppColors.primaryLight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.025, vertical: height * 0.008),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppUtils.monthToName(
                          int.parse(activity.date.split('-')[1])),
                      style: TextUtils.getStyle(
                        color: AppColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      activity.date.split('-')[0],
                      style: TextUtils.getStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.activity,
                    style: TextUtils.getStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        activity.time,
                        style: TextUtils.getStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
