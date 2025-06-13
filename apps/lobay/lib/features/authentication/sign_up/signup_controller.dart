import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_drop_down.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/register_body_model.dart';
import 'package:lobay/services/auth_service.dart';
import 'package:lobay/services/shared_pref_service.dart';
import 'package:lobay/features/authentication/repository/auth_repo.dart';
import 'package:lobay/features/bottom_navigation/bottom_navigation_main.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/commom_models/pairs_model.dart';
import 'package:lobay/utilities/commom_models/tuple_model.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import '../../../core/network/network_models/register_response_body.dart';

class SignupController extends GetxController {
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final formKey = GlobalKey<FormState>();

  RxBool isApiCalling = false.obs;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();

  RxList<Tuple> activities = <Tuple>[
    // Tuple(
    // first: 'Badminton',
    // second: Assets.imagesBadminton,
    // third: RxBool(false)),
    // Tuple(
    // first: 'Basketball',
    // second: Assets.imagesBaseketball,
    // third: RxBool(false)),
    // Tuple(first: 'Cricket', second: Assets.imagesCricket, third: RxBool(false)),
    // Tuple(first: 'Soccer', second: Assets.imagesSoccer, third: RxBool(false)),
    Tuple(first: 'Tennis', second: Assets.imagesTennis, third: RxBool(false)),
    // Tuple(
    //     first: 'Baseball', second: Assets.imagesBaseball, third: RxBool(false)),
  ].obs;
  RxList<Pair> selectedActivities = <Pair>[].obs;
  List<String> expertiseLevel = AppConstants.expertiseLevel;
  RxString gender = 'Male'.obs;

  Rx<XFile?> profileImage = Rx<XFile?>(null);

  void showDatePickerAdaptive(BuildContext context) {
    if (!GetPlatform.isAndroid) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
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
                    // Trigger form validation after date selection
                    formKey.currentState?.validate();
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
                onPressed: () {
                  Navigator.of(context).pop();
                  // // Trigger form validation after closing the picker
                  formKey.currentState?.validate();
                },
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
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      ).then(
        (pickedDate) {
          if (pickedDate != null) {
            dateOfBirthController.text =
                pickedDate.toLocal().toString().split(' ')[0];
            // Trigger form validation after date selection
            formKey.currentState?.validate();
          } else {
            dateOfBirthController.text = '';
          }
        },
      );
    }
  }

  Future<String> showExpertiseLevelDialog(String activityName) async {
    RxString selectedValue = expertiseLevel.first.obs;
    return await Get.defaultDialog(
      barrierDismissible: false,
      title: 'Select  Level',
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Kindly select level of expertise you have in the this activity.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            AppDropDown(
              options: expertiseLevel,
              hint: 'Select level',
              selectedValue: selectedValue,
              borderColor: AppColors.primaryLight,
            ),
            SizedBox(height: 20),
            AppButton(
              buttonText: 'Done',
              onPressed: () {
                //remove the previous value if it exists
                selectedActivities
                    .removeWhere((element) => element.first == activityName);
                selectedActivities.add(
                  Pair(
                    activityName,
                    selectedValue.value,
                  ),
                );
                activities
                    .firstWhere((element) => element.first == activityName)
                    .third
                    .value = true;
                Get.back(result: selectedValue.value);
                log('Selected Value: ${selectedValue.value}');
                log('Selected Activities: $selectedActivities');
                log('Activities: $activities');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = XFile(pickedFile.path);
      update();
    }
  }

  Future<bool> signup() async {
    try {
      final User? user = await AuthService().signUpWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
      if (user != null) {
        List<Activity> activities = [];
        for (var activity in selectedActivities) {
          activities.add(Activity(
            name: activity.first,
            expertiseLevel: activity.second,
          ));
        }

        // Create base model without profile image
        final RegisterBodyModel registerBodyModel = RegisterBodyModel(
          userId: user.uid,
          email: emailController.text,
          name: nameController.text.trim(),
          gender: gender.value,
          dateOfBirth: dateOfBirthController.text,
          postalCode: postalCodeController.text.trim(),
          phone: phoneController.text.trim(),
          signInWith: 'email_password',
          activities: activities,
        );

        // Only add profile image if it exists
        if (profileImage.value != null) {
          registerBodyModel.profileImage = await profileImage.value!
              .readAsBytes()
              .then((value) => 'data:image/png;base64,${base64Encode(value)}');
        }

        final RegisterResponseBody? registerResponse =
            await _authRepo.register(registerBodyModel);

        if (registerResponse != null) {
          if (registerResponse.success) {
            // Registration successful
            log('Registration successful: ${registerResponse.user}');
            await AppSnackbar.showSuccessSnackBar(
                message: 'Registration successful');

            await PreferencesManager.getInstance()
                .setStringValue('userId', registerResponse.user.userId);
            await PreferencesManager.getInstance()
                .setStringValue('userName', registerResponse.user.name);
            await PreferencesManager.getInstance()
                .setStringValue('token', registerResponse.token);
            await PreferencesManager.getInstance()
                .setStringValue('userEmail', registerResponse.user.email);

            Get.offAll(() => BottomNavigationScreen());
          } else {
            AppSnackbar.showErrorSnackBar(
                message: 'Registration failed: ${registerResponse.token}');
          }
        } else {
          AppSnackbar.showErrorSnackBar(message: 'Registration failed');
        }
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-up error
      log('Sign-up error: $e');
      AppSnackbar.showErrorSnackBar(message: e.message.toString());
      return false;
    }
  }

  Future<bool> signupWithGoogle() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<Activity> activities = [];
        for (var activity in selectedActivities) {
          activities.add(Activity(
            name: activity.first,
            expertiseLevel: activity.second,
          ));
        }

        // Create base model without profile image
        final RegisterBodyModel registerBodyModel = RegisterBodyModel(
          userId: user.uid,
          email: emailController.text,
          name: nameController.text.trim(),
          gender: gender.value,
          dateOfBirth: dateOfBirthController.text,
          postalCode: postalCodeController.text.trim(),
          phone: phoneController.text.trim(),
          signInWith: 'google',
          activities: activities,
        );

        // Only add profile image if it exists
        if (profileImage.value != null) {
          registerBodyModel.profileImage = await profileImage.value!
              .readAsBytes()
              .then((value) => 'data:image/png;base64,${base64Encode(value)}');
        }

        final RegisterResponseBody? registerResponse =
            await _authRepo.register(registerBodyModel);

        if (registerResponse != null) {
          if (registerResponse.success) {
            // Registration successful
            log('Registration successful: ${registerResponse.user}');
            await AppSnackbar.showSuccessSnackBar(
                message: 'Registration successful');

            await PreferencesManager.getInstance()
                .setStringValue('userId', registerResponse.user.userId);
            await PreferencesManager.getInstance()
                .setStringValue('userName', registerResponse.user.name);
            await PreferencesManager.getInstance()
                .setStringValue('token', registerResponse.token);
            await PreferencesManager.getInstance()
                .setStringValue('userEmail', registerResponse.user.email);

            Get.offAll(() => BottomNavigationScreen());
          } else {
            AppSnackbar.showErrorSnackBar(
                message: 'Registration failed: ${registerResponse.token}');
          }
        } else {
          AppSnackbar.showErrorSnackBar(message: 'Registration failed');
        }
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-up error
      log('Sign-up error: $e');
      AppSnackbar.showErrorSnackBar(message: e.message.toString());
      return false;
    }
  }

  populateIfSignupWithGoogle() {
    if (FirebaseAuth.instance.currentUser != null) {
      emailController.text = FirebaseAuth.instance.currentUser!.email!;
      nameController.text = FirebaseAuth.instance.currentUser!.displayName!;
    }
  }
}
