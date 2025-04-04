import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SelectActivityTopBar extends StatelessWidget with DeviceSizeUtil {


  const SelectActivityTopBar({ super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Container(
      height: height * 0.15,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
      ),
      child: Padding(
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
                  child: Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  'Activity',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.032,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Select activities of your interest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
