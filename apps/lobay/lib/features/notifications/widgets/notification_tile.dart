import 'package:flutter/material.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class NotificationTile extends StatelessWidget with DeviceSizeUtil {
  const NotificationTile({super.key});

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
            radius: height * 0.035,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1677631231234-1234567890ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
            ),
          ),
        ),
        SizedBox(
          width: width * 0.04,
        ),

        Flexible(
          flex: 3,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: AppButton(
                          buttonText: 'Accept',
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
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grey,
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
