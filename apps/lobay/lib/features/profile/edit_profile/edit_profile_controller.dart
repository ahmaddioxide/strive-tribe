import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobay/features/authentication/repository/auth_repo.dart';
import 'package:lobay/features/onboarding/onboarding_screen.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class EditProfileController extends GetxController {
  RxBool isGoogleLogin = false.obs;
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  RxString gender = 'Male'.obs;
  RxString profileImage = ''.obs;
  Rx<XFile> profileImageFile = XFile('').obs;

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
                // Perform logout action
                // Navigator.of(context).pop();
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
}
