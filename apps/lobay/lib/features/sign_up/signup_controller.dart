import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_drop_down.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/services/auth_service.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/commom_models/pairs_model.dart';
import 'package:lobay/utilities/commom_models/tuple_model.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();

  RxList<Tuple> activities = <Tuple>[
    Tuple(
        first: 'Badminton',
        second: Assets.imagesBadminton,
        third: RxBool(false)),
    Tuple(
        first: 'Basketball',
        second: Assets.imagesBaseketball,
        third: RxBool(false)),
    Tuple(first: 'Cricket', second: Assets.imagesCricket, third: RxBool(false)),
    Tuple(first: 'Soccer', second: Assets.imagesSoccer, third: RxBool(false)),
    Tuple(first: 'Tennis', second: Assets.imagesTennis, third: RxBool(false)),
    Tuple(
        first: 'Baseball', second: Assets.imagesBaseball, third: RxBool(false)),
  ].obs;
  RxList<Pair> selectedActivities = <Pair>[].obs;
  List<String> expertiseLevel = AppConstants.expertiseLevel;
  RxString gender = 'Male'.obs;

  Rx<XFile?> profileImage = Rx<XFile?>(null);

  void showDatePickerAdaptive(BuildContext context) {
    if (GetPlatform.isAndroid) {
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
    // return false;
    try {
      final User? user = await AuthService().signUpWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
      if (user != null) {
        // User signed up successfully
        // You can perform additional actions here, like navigating to another screen
        final body = {
          'user_id': user.uid,
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'name': nameController.text.trim(),
          'gender': gender.value.toLowerCase(),
          'date_of_birth': dateOfBirthController.text, // YYYY-MM-DD
          'location': locationController.text.trim(),
          'phone': phoneController.text.trim(),
          'profile_image': profileImage.value?.path,
          //selected activities to map with activity name and expertise level
          'activities': selectedActivities
              .map((activity) => {
                    'name': activity.first,
                    'expertise_level': activity.second,
                  })
              .toList(),
        };

        log('Body: $body');
        return true;
      } else {
        // Sign-up failed
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-up error
      log('Sign-up error: $e');
      AppSnackbar.showErrorSnackBar(message: e.message.toString());
      return false;
    }
  }
}
