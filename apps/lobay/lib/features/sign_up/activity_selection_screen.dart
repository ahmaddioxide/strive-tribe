import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/features/sign_up/signup_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class ActivitySelectionScreen extends StatelessWidget with DeviceSizeUtil {
  const ActivitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: Column(
        children: [
          TopContainer(height: height, width: width),
          SizedBox(height: height * 0.02),
          Obx(() {
            return Expanded(
              child: GridView.builder(
                // physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: width * 0.02,
                  mainAxisSpacing: height * 0.02,
                  childAspectRatio: 4 / 4,
                ),
                itemCount: signupController.activities.length,
                itemBuilder: (context, index) {
                  // final activity = signupController.activities[index];
                  return ActivityContainer(
                    index: index,
                  );
                },
              ),
            );
          }),
          SizedBox(height: height*0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: AppButton(
              buttonText: 'Register',
              onPressed: () {},
            ),
          ),
          SizedBox(height: height*0.02,)
        ],
      ),
    );
  }
}

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

class TopContainer extends StatelessWidget {
  final double height;
  final double width;

  const TopContainer({required this.height, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
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
