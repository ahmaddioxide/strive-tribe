import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobay/core/network/network_models/create_activity_body.dart';
import 'package:lobay/services/shared_pref_service.dart';
import 'package:lobay/features/create_activity/activity_repo/activity_repo.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class CreateActivityController extends GetxController {
  RxBool isApiCalling = false.obs;
  final ActivityRepo activityRepo = ActivityRepo();
  RxString selectedActivity = 'Badminton'.obs;
  RxString selectedPlayerLevel = 'Beginner'.obs;
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Rx<XFile?> videoFile = Rx<XFile?>(null);

  final formKey = GlobalKey<FormState>();




  void showDatePickerAdaptive(BuildContext context) {
    // if (GetPlatform.isIOS) {
    //   showCupertinoModalPopup(
    //     context: context,
    //     builder: (_) => Container(
    //       height: 300,
    //       color: AppColors.white,
    //       child: Column(
    //         children: [
    //           SizedBox(
    //             height: 200,
    //             child: CupertinoDatePicker(
    //               initialDateTime: DateTime.now(),
    //               minimumDate: DateTime.now(),
    //               mode: CupertinoDatePickerMode.date,
    //               onDateTimeChanged: (DateTime newDate) {
    //                 dateController.text =
    //                     newDate.toLocal().toString().split(' ')[0];
    //               },
    //             ),
    //           ),
    //           CupertinoButton(
    //             color: AppColors.primaryLight,
    //             child: Text(
    //               'Done',
    //               style: TextStyle(
    //                   color: AppColors.white, fontWeight: FontWeight.bold),
    //             ),
    //             onPressed: () => Navigator.of(context).pop(),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // } else {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
          dateController.text = pickedDate.toLocal().toString().split(' ')[0];
        } else {
          dateController.text = '';
        }
      },
    );
    // }
  }

void showTimePickerAdaptive(BuildContext context) {
    if (GetPlatform.isIOS) {
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
                  use24hFormat: false,
                  initialDateTime: DateTime.now(),
                  mode: CupertinoDatePickerMode.time,
                  onDateTimeChanged: (DateTime newTime) {
                    final formattedTime = TimeOfDay.fromDateTime(newTime).format(context);
                    timeController.text = formattedTime;
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
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
        (pickedTime) {
          if (pickedTime != null) {
            timeController.text = pickedTime.format(context);
          } else {
            timeController.text = '';
          }
        },
      );
    }
  }
  Future<void> pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoFile.value = XFile(pickedFile.path);
    }
  }

  Future<bool> createActivity() async {
    // video to base64

    final String base64String = await convertVideoToBase64();
    // log('BASE 64:$base64String');

    final changedDate = dateController.text.split('-').reversed.join('-');
    final userId = await PreferencesManager.getInstance()
        .getStringValue('userId', FirebaseAuth.instance.currentUser!.uid);
    final CreateActivityBody createActivityBody = CreateActivityBody(
      userId: userId,
      Activity: selectedActivity.value,
      PlayerLevel: selectedPlayerLevel.value,

      ///format date to dd-mm-yyyy
      Date: changedDate,
      Time: timeController.text,
      notes: notesController.text,
      video: 'data:video/mp4;base64,$base64String',
    );

    log(createActivityBody.video.toString());

    final response = await activityRepo.createActivity(createActivityBody);

    if (response != null) {
      log('Activity created successfully');
      Get.snackbar(
        'Success',
        'Activity created successfully',
        backgroundColor: AppColors.primaryLight,
        colorText: AppColors.white,
      );

      return true;
    } else {
      log('Failed to create activity');
      Get.snackbar(
        'Error',
        'Failed to create activity',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    }
    return false;
  }

  Future<String> convertVideoToBase64() async {
    // check video file is not null
    if (videoFile.value == null) {
      return '';
    }
    //check video size
    final fileSize = await videoFile.value!.length();

    log('Video file size: $fileSize');

    final bytes = await videoFile.value!.readAsBytes();
    log('Video bytes: ${bytes.length}');
    final String base64String = base64Encode(bytes);
    log('BASE 64:${base64String.substring(0, 299)}');
    return base64String;
  }
}
