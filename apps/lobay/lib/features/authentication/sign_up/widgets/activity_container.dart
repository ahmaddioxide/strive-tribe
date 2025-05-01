import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/features/authentication/sign_up/signup_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class ActivityContainer extends StatelessWidget with DeviceSizeUtil {
  final int index;

  ActivityContainer({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();
    final height = getDeviceHeight();
    return AppClickWidget(
      onTap: () {
        signupController
            .showExpertiseLevelDialog(signupController.activities[index].first);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryLight,
            width: 2,
          ),
        ),
        child: Obx(() {
          return Stack(
            children: [
              signupController.activities[index].third.value == true
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryLight,
                          size: 26,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImageWidget(
                        imagePathOrURL:
                            signupController.activities[index].second,
                        height: 100,
                        width: 100),
                    SizedBox(height: height * 0.01),
                    Text(
                      signupController.activities[index].first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: height * 0.01),
            ],
          );
        }),
      ),
    );
  }
}
