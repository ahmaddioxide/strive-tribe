import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/features/home/home_screen_controller.dart';
import 'package:lobay/features/home/widgets/activities_tile.dart';
import 'package:lobay/utilities/app_utils/app_utils.dart';

class ActivitiesList extends StatelessWidget {
  final controller = Get.find<HomeScreenController>();

  ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.activitiesList.isEmpty) {
        return const Center(
          child: Text('No activities found'),
        );
      } else {
        return ListView.builder(
          itemCount: controller.activitiesList.length,
          itemBuilder: (context, index) {
            final activity = controller.activitiesList[index];
            return ActivitiesTile(
              title: activity.name,
              subtitle: activity.time,
              date: AppUtils.convertToDateTime(activity.date) ?? DateTime.now(),
            );
          },
        );
      }
    });
  }
}
