import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/get_user_reponse_body.dart';
import 'package:lobay/features/authentication/repository/auth_repo.dart';
import 'package:lobay/features/onboarding/onboarding_screen.dart';
import 'package:lobay/features/profile/repository/profile_repo.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class ProfileController extends GetxController {
  RxBool isGoogleLogin = false.obs;
  RxBool isLoading = false.obs;
  RxBool isApiCalling = false.obs;
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  RxString gender = 'Male'.obs;
  RxString initialCountry = ''.obs;
  RxString profileImage = ''.obs;
  Rx<XFile?> profileImageFile = Rx<XFile?>(null);

  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  final profileRepo = ProfileRepo();

  @override
  void onInit() {
    isLoading.value = true;
    super.onInit();
    getUser();
    isLoading.value = false;
  }

  Future<void> getUser() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final response = await profileRepo.getUser(userId: userId);

    if (response == null) {
      AppSnackbar.showErrorSnackBar(
          message: 'Something went wrong while fetching profile');
      return;
    }
    userModel.value = response;
    extractAndRemoveCountryCode();
    emailController.text = response.email;
    nameController.text = response.name;
    phoneController.text = response.phoneNumber;
    dateOfBirthController.text = response.dateOfBirth;
    gender.value = response.gender;
    postalCodeController.text = response.postalCode;
    profileImage.value = response.profileImage;
  }

  Future<void> pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile.value = XFile(pickedFile.path);
      update();
    }
  }

  void showLogoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Yes'),
                onPressed: () async {
                  // Perform logout action
                  // Navigator.of(context).pop();
                  await AuthenticationRepository().logout();
                  Get.offAll(() => OnboardingScreen());
                },
              ),
            ],
          );
        }
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.white,
              ),
              child: Text('Yes'),
              onPressed: () async {
                await AuthenticationRepository().logout();
                Get.offAll(() => OnboardingScreen());
              },
            ),
          ],
        );
      },
    );
  }

  void showDatePickerAdaptive(BuildContext context) {
    if (!GetPlatform.isAndroid) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) =>
            Container(
              height: 300,
              color: AppColors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime newDate) {
                        dateOfBirthController.text =
                        newDate.toLocal().toString().split(' ')[0];
                      },
                    ),
                  ),
                  CupertinoButton(
                    color: AppColors.primaryLight,
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
      );
    } else {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        barrierColor: Colors.black.withAlpha(50),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryLight,
                onPrimary: AppColors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogTheme: DialogThemeData(backgroundColor: Colors.white),
            ),
            child: child!,
          );
        },
      ).then(
            (pickedDate) {
          if (pickedDate != null) {
            dateOfBirthController.text =
            pickedDate.toLocal().toString().split(' ')[0];
          } else {
            dateOfBirthController.text = '';
          }
        },
      );
    }
  }

  Future<void> extractAndRemoveCountryCode() async {
    String? phoneNumber = userModel.value?.phoneNumber??'';
    final phoneNumberNew =
    PhoneNumber.fromCompleteNumber(completeNumber: phoneNumber!);
    initialCountry.value = phoneNumberNew.countryISOCode;
    userModel.value?.phoneNumber = phoneNumberNew.number;
  }

  Future<void> updateProfile() async {
    isApiCalling.value = true;
    Map<String, dynamic> newBody = {};
    if (profileImageFile.value != null) {
      final String imageBase64 =
      await profileImageFile.value!.readAsBytes().then((value) {
        return base64Encode(value);
      });

      newBody = {
        'user_id': '${userModel.value?.userId}',
        'name': nameController.text,
        'gender': gender.value,
        'dateOfBirth': dateOfBirthController.text,
        'phoneNumber': phoneController.text,
        'profile_image': 'data:image/png;base64, $imageBase64',
        'postalCode': postalCodeController.text,
      };
    } else {
      newBody = {
        'user_id': '${userModel.value?.userId}',
        'name': nameController.text,
        'gender': gender.value,
        'dateOfBirth': dateOfBirthController.text,
        'phoneNumber': phoneController.text,
        'postalCode': postalCodeController.text,
      };
    }
    final isUpdated = await profileRepo.updateUser(data: newBody);
    isApiCalling.value = false;
    if (isUpdated) {
      Get.back();
      AppSnackbar.showSuccessSnackBar(message: 'Profile updated successfully');
      await getUser();
    } else {
      AppSnackbar.showErrorSnackBar(
          message: 'Something went wrong while updating profile');
    }
  }
}
