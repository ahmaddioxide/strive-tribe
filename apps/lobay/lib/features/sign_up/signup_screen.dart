import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_drop_down.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/common_widgets/app_text_field.dart';
import 'package:lobay/features/sign_up/signup_controller.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SignupScreen extends StatelessWidget with DeviceSizeUtil {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.put(SignupController());
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopContainer(height: height, width: width),
            SignupForm(height: height, width: width),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final double height;
  final double width;

  const SignupForm({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.01),
          Text(
            'Email',
            style: TextStyle(
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: height * 0.006),
          AppTextField(
            hintText: 'Email',
            controller: signupController.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(height: height * 0.006),
                    AppTextField(
                      hintText: 'Name',
                      controller: signupController.nameController,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
              ),
              SizedBox(width: width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender', style: TextStyle(color: AppColors.grey)),
                    SizedBox(height: height * 0.006),
                    AppDropDown(
                      options: ['Male', 'Female'],
                      hint: 'Select Gender',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date of birth',
                      style: TextStyle(
                        color: AppColors.grey,
                      ),
                    ),
                    SizedBox(height: height * 0.006),
                    AppTextField(
                      hintText: 'Set DoB',
                      controller: signupController.dateOfBirthController,
                      keyboardType: TextInputType.datetime,
                      // enabled: false,/
                      readOnly: true,
                      trailingIcon: Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.grey,
                      ),
                      onTap: () {
                        log('Date of Birth');
                        signupController.showDatePickerAdaptive(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: width * 0.01),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: TextStyle(color: AppColors.grey)),
                    SizedBox(height: height * 0.006),
                    AppTextField(
                      hintText: 'Set Location',
                      controller: signupController.locationController,
                      keyboardType: TextInputType.streetAddress,
                      trailingIcon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Text('Phone number', style: TextStyle(color: AppColors.grey)),
          SizedBox(height: height * 0.006),
          IntlPhoneField(
            decoration: InputDecoration(
              hintText: '(123) 456-7890',
              hintStyle: TextStyle(color: AppColors.grey),
              border: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            initialCountryCode: 'GB',
            onChanged: (phone) {
              signupController.phoneController.text = phone.completeNumber;
            },
            dropdownIcon: Icon(Icons.keyboard_arrow_down_outlined),
            dropdownIconPosition: IconPosition.trailing,
            flagsButtonPadding: EdgeInsets.only(left: 10),
          ),
          Text('Set password', style: TextStyle(color: AppColors.grey)),
          SizedBox(height: height * 0.006),
          AppTextField(
            hintText: 'Password',
            controller: signupController.passwordController,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
          SizedBox(height: height * 0.01),
          Text('Profile Picture', style: TextStyle(color: AppColors.grey)),
          SizedBox(height: height * 0.006),
          Row(
            children: [
              signupController.profileImage.value == null
                  ? AppImageWidget(
                      imagePathOrURL: Assets.svgsCircleUser,
                      height: 50,
                      width: 50)
                  : CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.file(
                          File(signupController.profileImage.value!.path),
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              TextButton(
                onPressed: () async {
                  log('Upload Profile Picture');
                  await signupController.pickImage();
                },
                child: Text(
                  'Upload profile picture',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          AppButton(
            isEnabled: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Icon(Icons.arrow_forward, color: AppColors.white),
              ],
            ),
            onPressed: () {},
          ),
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
      height: height * 0.18,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
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
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.032,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
