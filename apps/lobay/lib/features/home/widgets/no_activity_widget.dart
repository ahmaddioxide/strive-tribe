import 'package:flutter/material.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class NoActivityWidget extends StatelessWidget with DeviceSizeUtil {
  const NoActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height =getDeviceHeight();
    final width = getDeviceWidth();
    return               Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppImageWidget(
            imagePathOrURL: Assets.svgsNoActivity,
            height: height * 0.15,
            width: width * 0.15),
        SizedBox(height: height * 0.02),
        Text(
          'No games in your area',
          style: TextUtils.getStyle(
            color: AppColors.primaryLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'We\'ll let you know when any game is added in the area.',
          style: TextUtils.getStyle(
            color: AppColors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

  }
}
