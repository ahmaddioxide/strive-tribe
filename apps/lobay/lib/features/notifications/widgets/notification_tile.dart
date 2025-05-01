import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/notifications_reponse_model.dart';
import 'package:lobay/features/notifications/notification_details_and_user_stats_screen.dart';
import 'package:lobay/features/notifications/notifications_controller.dart';
import 'package:lobay/utilities/app_utils/app_utils.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class NotificationTile extends StatelessWidget with DeviceSizeUtil {
  final _controller = Get.find<NotificationsController>();
  final NotificationModel notificationModel;

  NotificationTile({
    super.key,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return AppClickWidget(
      onTap: () {
        Get.to(
            NotificationAndUserStatsScreen(
              requestorId: notificationModel.requesterId,
              activityId: notificationModel.activityId,
              participationId: notificationModel.participationId,
              notificationId: notificationModel.id,
            ),
            arguments: {
              'notificationId': notificationModel.id,
              'participationId': notificationModel.participationId,
              'userId': notificationModel.userId,
              'isFromNotification': true,
            });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            child: CircleAvatar(
              radius: height * 0.04,
              backgroundImage: NetworkImage(notificationModel.profileImage),
            ),
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notificationModel.title + notificationModel.message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      AppUtils.timeAgo(notificationModel.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: width * 0.3,
                      height: height * 0.04,
                      child: AppButton(
                        buttonText: 'Accept',
                        textSize: 16,
                        onPressed: () async {
                          await _controller
                              .acceptRequest(
                            notificationId: notificationModel.id,
                            participationId: notificationModel.participationId,
                          )
                              .then((value) async {
                            if (value) {
                              AppSnackbar.showSuccessSnackBar(
                                  message: 'Accepted');
                              await _controller.fetchNotifications();
                            } else {
                              AppSnackbar.showErrorSnackBar(
                                  message: 'Failed to accept');
                            }
                          });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _controller
                            .declineRequest(
                          notificationId: notificationModel.id,
                          participationId: notificationModel.participationId,
                        )
                            .then((value) async {
                          if (value) {
                            AppSnackbar.showSuccessSnackBar(
                                message: 'Declined');
                            await _controller.fetchNotifications();
                          } else {
                            AppSnackbar.showErrorSnackBar(
                                message: 'Failed to decline');
                          }
                        });
                      },
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
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
  }
}
