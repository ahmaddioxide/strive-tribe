import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/common_widgets/app_text_field.dart';
import 'package:lobay/features/sign_in/signin_controller.dart';
import 'package:lobay/features/sign_up/signup_screen.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/app_utils/validators.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SigninScreen extends StatelessWidget with DeviceSizeUtil {
  final signInController = Get.put(SignInController());

  SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SigninScreenTopContainer(),
            LoginForm(height: height, width: width),
          ],
        ),
      ),
    );
  }
}

class SigninScreenTopContainer extends StatelessWidget with DeviceSizeUtil {
  const SigninScreenTopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
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
                  onPressed: () {
                    Get.to(() => SignupScreen());
                  },
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
    final signInController = Get.find<SignInController>();
    return Form(
      key: signInController.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            Text(
              'Email',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
            SizedBox(height: height * 0.006),
            AppTextField(
              hintText: 'Email',
              controller: signInController.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validator.validateEmail,
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Password',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
            SizedBox(height: height * 0.006),
            AppTextField(
              hintText: 'Password',
              controller: signInController.passwordController,
              keyboardType: TextInputType.emailAddress,
              isPassword: true,
              validator: Validator.validatePassword,
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(() {
                      return Checkbox(
                        checkColor: AppColors.white,
                        activeColor: AppColors.primaryLight,
                        value: signInController.rememberMe.value,
                        onChanged: (value) {
                          signInController.rememberMe.value =
                              !signInController.rememberMe.value;
                        },
                      );
                    }),
                    Text(
                      'Remember me',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decorationColor: AppColors.grey,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            AppButton(
              buttonText: 'Log In',
              onPressed: () {
                //validate and submit
                if (signInController.formKey.currentState!.validate()) {
                  // signInController.formKey.currentState!.save();
                  log('Validated');
                  // signInController.signIn();
                } else {
                  log('Not Validated');
                }
              },
            ),
            //-----------------OR-----------------
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.border,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Text(
                    'Or continue with',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.border,
                    thickness: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: height * 0.06,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImageWidget(
                        imagePathOrURL: Assets.assetsGoogleIcon,
                      ),
                      SizedBox(width: width * 0.03),
                      Text(
                        'Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.06,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImageWidget(
                        imagePathOrURL: Assets.imagesFacebookLogo,
                      ),
                      SizedBox(width: width * 0.03),
                      Text(
                        'Facebook',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Spacer(),
            // By signing up, you agree to the Terms of Service and Data Processing Agreement
            SizedBox(height: height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By signing up, you agree to the ',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppClickWidget(
                  onTap: () {},
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decorationColor: AppColors.grey,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' and ',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppClickWidget(
                  onTap: () {},
                  child: Text(
                    'Data Processing Agreement',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      decorationColor: AppColors.grey,
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
