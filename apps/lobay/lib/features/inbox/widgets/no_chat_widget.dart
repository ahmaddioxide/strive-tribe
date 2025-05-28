import 'package:flutter/material.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

import '../../../generated/assets.dart';

class NoChatWidget extends StatelessWidget with DeviceSizeUtil {
  const NoChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppImageWidget(
          imagePathOrURL: Assets.imagesMessageEmpty,
          height: height * 0.2,
          width: width * 0.4,
        ),
        SizedBox(height: height * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Text(
            'No Chats Yet',
            style: TextUtils.getStyle(
              color: AppColors.black,
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Text(
            'Want to chat with a player?\nCheck players in your area.',
            style: TextUtils.getStyle(
              color: AppColors.black,
              fontSize: width * 0.04,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
