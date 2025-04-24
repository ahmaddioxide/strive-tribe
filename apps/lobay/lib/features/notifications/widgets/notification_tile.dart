import 'package:flutter/material.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/core/network/network_models/notifications_reponse_model.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class NotificationTile extends StatelessWidget with DeviceSizeUtil {
  final NotificationModel notificationModel;

  const NotificationTile({
    super.key,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Row(
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
              Text(
                notificationModel.title + notificationModel.message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
                      onPressed: () {},
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
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

        // Column(
        //
        //
        //   children: [
        //     const Text('Lorem ipsum dolor sit amet, .'),
        //     const SizedBox(
        //       height: 5,
        //     ),
        //     Row(
        //       children: [
        //         AppButton(
        //           buttonText: 'Accept',
        //           onPressed: () {},
        //         ),
        //         const SizedBox(
        //           width: 10,
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
