import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget with DeviceSizeUtil {
  OnboardingScreen({super.key});

  final OnboardingController _controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = getDeviceHeight();
    final double deviceWidth = getDeviceWidth();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.05,
                vertical: deviceHeight * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: deviceWidth,
                  ),
                  Text(
                    "Welcome to ${AppConstants.appName} !",
                    style: TextUtils.getStyle(
                      fontSize: deviceWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  Row(
                    children: [
                      Text(
                        'Want to skip onboarding? ',
                        style: TextUtils.getStyle(),
                      ),
                      AppClickWidget(
                        onTap: () {
                          _controller.skipOnboarding();
                        },
                        child: Text(
                          'Skip >',
                          style: TextUtils.getStyle(
                            fontWeight: FontWeight.bold,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Expanded PageView for the main content
            Expanded(
              child: PageView(
                controller: _controller.pageController,
                onPageChanged: (index) {
                  _controller.currentPage.value = index;
                },
                children: [
                  /// PAGE 1
                  OnboardingPage(
                    deviceHeight: deviceHeight,
                    deviceWidth: deviceWidth,
                    headline: "Discover Games",
                    description:
                        "Stay updated with games happening in your area. Browse scheduled games and never miss an opportunity to join the action!",
                    illustration: Assets.imagesOnboarding1,
                  ),
                  OnboardingPage(
                    deviceHeight: deviceHeight,
                    deviceWidth: deviceWidth,
                    headline: "Connect With Players",
                    description:
                        "Meet and chat with players in your neighborhood. Build your gaming circle and foster lasting connections through shared interests.",
                    illustration: Assets.imagesOnboarding2,
                  ),
                  OnboardingPage(
                    deviceHeight: deviceHeight,
                    deviceWidth: deviceWidth,
                    headline: "Connect With Players",
                    description:
                        "Meet and chat with players in your neighborhood. Build your gaming circle and foster lasting connections through shared interests.",
                    illustration: Assets.imagesOnboarding3,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.03,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          3,
                          (index) => Obx(
                            () => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  EdgeInsets.only(right: deviceWidth * 0.01),
                              height: deviceHeight * 0.008,
                              width: deviceWidth * 0.05,
                              decoration: BoxDecoration(
                                color: _controller.currentPage.value == index
                                    ? AppColors.black
                                    : AppColors.grey.withAlpha(100),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: deviceHeight * 0.03),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: _controller.nextPage,
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final double deviceHeight;
  final double deviceWidth;
  final String headline;
  final String description;
  final String illustration;

  const OnboardingPage({
    super.key,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.headline,
    required this.description,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: deviceHeight * 0.01),
          SizedBox(
            height: deviceHeight * 0.3,
            width: deviceWidth,
            child: Image.asset(
              illustration,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: deviceHeight * 0.06),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: TextUtils.getStyle(
                    fontSize: deviceWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: deviceHeight * 0.01),
                Text(
                  description,
                  textAlign: TextAlign.start,
                  style: TextUtils.getStyle(
                    fontSize: deviceWidth * 0.04,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
