import 'package:flutter/material.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';

import '../../../utilities/theme_utils/app_colors.dart';

class ChatRoomTile extends StatelessWidget with DeviceSizeUtil {
  const ChatRoomTile({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return ListTile(
      leading: CircleAvatar(
        radius: width * 0.06,
        backgroundImage: NetworkImage(''),
      ),
      title: Text(
        'Test Name',
        style: TextUtils.getStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'Test last message',
        style: TextUtils.getStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '10:00 AM',
            style: TextUtils.getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey),
          ),
          SizedBox(height: height * 0.005),
          Container(
            width: width * 0.05,
            height: width * 0.05,
            decoration: BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '5',
                style: TextUtils.getStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
