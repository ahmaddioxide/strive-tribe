import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_drop_down.dart';
import 'package:lobay/common_widgets/app_image_widget.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/common_widgets/app_text_field.dart';
import 'package:lobay/features/authentication/sign_up/activity_selection_screen.dart';
import 'package:lobay/features/authentication/sign_up/signup_controller.dart';
import 'package:lobay/features/authentication/sign_up/widgets/signup_screen_top_container.dart';

import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/app_utils/validators.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SignupScreen extends StatelessWidget with DeviceSizeUtil {
  final bool isGoogleLogin;

  const SignupScreen({super.key, this.isGoogleLogin = false});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.put(SignupController());
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    if (isGoogleLogin) {
      log('Google Login in signup screen');
      signupController.populateIfSignupWithGoogle();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SignupScreenTopContainer(height: height, width: width),
            SignupForm(height: height, width: width,isGoogleLogin: isGoogleLogin,),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final bool isGoogleLogin;
  final double height;
  final double width;

  const SignupForm(
      {super.key,
      required this.height,
      required this.width,
      this.isGoogleLogin = false});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();

    return Form(
      key: signupController.formKey,
      child: Padding(
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
              validator: Validator.validateEmail,
              enabled: !isGoogleLogin,
            ),
            SizedBox(height: height * 0.01),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: height * 0.006),
                      AppTextField(
                        hintText: 'Name',
                        controller: signupController.nameController,
                        keyboardType: TextInputType.name,
                        validator: Validator.validateName,
                        enabled: !isGoogleLogin,
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
                        selectedValue: signupController.gender,
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
                        validator: Validator.validateDateOfBirth,
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
                        validator: Validator.validateLocation,
                      ),
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
              autovalidateMode: AutovalidateMode.onUnfocus,
              onChanged: (phone) {
                signupController.phoneController.text = phone.completeNumber;
              },
              dropdownIcon: Icon(Icons.keyboard_arrow_down_outlined),
              dropdownIconPosition: IconPosition.trailing,
              flagsButtonPadding: EdgeInsets.only(left: 10),
            ),
            Text('Set password', style: TextStyle(color: AppColors.grey)),
            SizedBox(height: height * 0.006),
            !isGoogleLogin
                ? AppTextField(
                    hintText: 'Password',
                    controller: signupController.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: Validator.validatePassword,
                  )
                : SizedBox.shrink(),
            SizedBox(height: height * 0.01),
            Text('Profile Picture', style: TextStyle(color: AppColors.grey)),
            SizedBox(height: height * 0.006),
            Obx(() {
              return Row(
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
                      signupController.profileImage.value == null
                          ? 'Upload profile picture'
                          : 'Change profile picture',
                      style: TextStyle(
                        color: signupController.profileImage.value == null
                            ? AppColors.primaryLight
                            : AppColors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            signupController.profileImage.value == null
                                ? AppColors.primaryLight
                                : AppColors.grey,
                      ),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: height * 0.02),
            AppButton(
              isEnabled: true,
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
              onPressed: () async {
                //validate form
                // await signupController.signup();

                if (signupController.formKey.currentState!.validate()) {
                  // signupController.formKey.currentState!.save();
                  Get.to(
                    () => ActivitySelectionScreen(
                      isGoogleLogin: isGoogleLogin,
                    ),
                  );
                  log('Form is valid');
                } else {
                  log('Form is invalid');
                  AppSnackbar.showErrorSnackBar(
                      message: 'Please enter the valid values to continue');
                }
              },
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
