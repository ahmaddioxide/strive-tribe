import 'package:flutter/material.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SigninScreen extends StatelessWidget with DeviceSizeUtil {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: Column(
        children: [
          TopContainer(height: height, width: width),
          LoginForm(height: height, width: width),
        ],
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
      height: height * 0.3,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppImageWidget(imagePathOrURL: Assets.imagesAppIconWhite),
                SizedBox(
                  width: width * 0.02,
                ),
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Sign in to your Account',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.045,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4),
            ),
            Row(
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.017,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.017,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.white,
                      decorationThickness: 1.5,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {

  final double height;
  final double width;
  const LoginForm({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

