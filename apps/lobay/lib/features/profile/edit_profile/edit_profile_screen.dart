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
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/app_utils/validators.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget with DeviceSizeUtil {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final controller = Get.find<EditProfileController>();

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              // vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: TextUtils.getStyle(
                    fontSize: 24,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateEmail,
                  enabled: false,
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
                            controller: controller.nameController,
                            keyboardType: TextInputType.name,
                            validator: Validator.validateName,
                            enabled: !controller.isGoogleLogin.value,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender',
                              style: TextStyle(color: AppColors.grey)),
                          SizedBox(height: height * 0.006),
                          AppDropDown(
                            options: ['Male', 'Female'],
                            hint: 'Select Gender',
                            selectedValue: controller.gender,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Date of birth',
                  style: TextStyle(
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppTextField(
                  hintText: 'Set DoB',
                  controller: controller.dateOfBirthController,
                  keyboardType: TextInputType.datetime,
                  // enabled: false,/
                  readOnly: true,
                  trailingIcon: Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.grey,
                  ),
                  onTap: () {
                    log('Date of Birth');
                    controller.showDatePickerAdaptive(context);
                  },
                  validator: Validator.validateDateOfBirth,
                ),
                SizedBox(height: height * 0.01),
                Text('Location', style: TextStyle(color: AppColors.grey)),
                SizedBox(height: height * 0.006),
                AppTextField(
                  hintText: 'Set Location',
                  controller: controller.locationController,
                  keyboardType: TextInputType.streetAddress,
                  trailingIcon: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.grey,
                  ),
                  validator: Validator.validateLocation,
                ),
                SizedBox(width: width * 0.01),
                Text('Phone number', style: TextStyle(color: AppColors.grey)),
                SizedBox(height: height * 0.006),
                IntlPhoneField(
                  initialCountryCode: controller.initialCountry.value,
                  controller: controller.phoneController,
                  disableLengthCheck: true,
                  validator: (value) {
                    if (value == null || value.completeNumber.isEmpty) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: '(123) 456-7890',
                    hintStyle: TextStyle(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // initialCountryCode: 'GB',
                  autovalidateMode: AutovalidateMode.disabled,
                  onChanged: (phone) {
                    controller.phoneController.text = phone.completeNumber;
                  },
                  dropdownIcon: Icon(Icons.keyboard_arrow_down_outlined),
                  dropdownIconPosition: IconPosition.trailing,
                  flagsButtonPadding: EdgeInsets.only(left: 10),
                ),
                // SizedBox(height: height * 0.01),
                // Text('Set password', style: TextStyle(color: AppColors.grey)),
                // SizedBox(height: height * 0.006),
                // !controller.isGoogleLogin.value
                //     ? AppTextField(
                //         hintText: 'Password',
                //         controller: controller.passwordController,
                //         keyboardType: TextInputType.visiblePassword,
                //         isPassword: true,
                //         validator: Validator.validatePassword,
                //       )
                //     : SizedBox.shrink(),
                SizedBox(height: height * 0.01),
                Text('Profile Picture',
                    style: TextStyle(color: AppColors.grey)),
                SizedBox(height: height * 0.006),
                Obx(
                  () {
                    return Row(
                      children: [
                        controller.profileImageFile.value == null
                            ? controller.profileImage.value.isEmpty
                                ? ClipOval(
                                    child: AppImageWidget(
                                        imagePathOrURL: Assets.svgsCircleUser,
                                        height: 50,
                                        width: 50),
                                  )
                                : ClipOval(
                                    child: AppImageWidget(
                                      height: 50,
                                      width: 50,
                                      networkImage: true,
                                      imagePathOrURL:
                                          controller.profileImage.value,
                                    ),
                                  )
                            : ClipOval(
                                child: AppImageWidget(
                                  height: 50,
                                  width: 50,
                                  imagePathOrURL:
                                      controller.profileImageFile.value!.path,
                                ),
                              ),
                        TextButton(
                          onPressed: () async {
                            log('Upload Profile Picture');
                            await controller.pickImage();
                          },
                          child: Text(
                            controller.profileImage.value.isEmpty
                                ? 'Upload profile picture'
                                : 'Change profile picture',
                            style: TextStyle(
                              color: controller.profileImage.value == null
                                  ? AppColors.primaryLight
                                  : AppColors.grey,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  controller.profileImage.value == null
                                      ? AppColors.primaryLight
                                      : AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: height * 0.02),
                Obx(() {
                  return AppButton(
                    isLoading: controller.isApiCalling.value,
                    isEnabled: true,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      //validate form
                      // await signupController.signup();

                      if (controller.formKey.currentState!.validate()) {
                        await controller.updateProfile();
                        log('Form is valid');
                      } else {
                        log('Form is invalid');
                        AppSnackbar.showErrorSnackBar(
                            message:
                                'Please enter the valid values to continue');
                      }
                    },
                  );
                }),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
