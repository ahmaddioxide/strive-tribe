import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/features/notifications/notifications_controller.dart';
import 'package:lobay/features/notifications/widgets/notification_tile.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class NotificationsScreen extends StatelessWidget with DeviceSizeUtil {
  final _controller = Get.put(NotificationsController());

  NotificationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Text(
              'Notifications',
              style: TextUtils.getStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Text(
              'Stay updated with all games.',
              style: TextUtils.getStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
            ),
            Obx(() {
              if (_controller.isLoading.value) {
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.3,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }
              if (_controller.notifications.isEmpty) {
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.28,
                    ),
                    Center(
                      child: AppImageWidget(
                        width: width * 0.2,
                        height: height * 0.1,
                        imagePathOrURL: Assets.imagesNotificationBell,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      'No notifications yet',
                      style: TextUtils.getStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                );
              }
              return Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return NotificationTile(
                      notificationModel: _controller.notifications[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: _controller.notifications.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
