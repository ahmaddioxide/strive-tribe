import 'package:flutter/material.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

import '../../../utilities/mixins/device_size_util.dart';

class ActivitiesTile extends StatelessWidget with DeviceSizeUtil {
  final String title;
  final String subtitle;
  final DateTime date;

  const ActivitiesTile({super.key, required this.title, required this.subtitle, required this.date});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return ListTile(
      leading: Container(
        height: height * 0.1,
        width: width * 0.14,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.month.toString(),
              style: TextUtils.getStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date.day.toString(),
              style: TextUtils.getStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      title: Text(
        title,
        style: TextUtils.getStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: Colors.grey,
            size: 26,
          ),
          SizedBox(width: 5),
          Text(
            subtitle,
            style: TextUtils.getStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
