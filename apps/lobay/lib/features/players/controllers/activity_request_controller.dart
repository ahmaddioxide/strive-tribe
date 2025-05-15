import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobay/utilities/constants/app_constants.dart';

import '../../../core/shared_preferences/shared_pref.dart';
import '../repo/players_repo.dart';

class ActivityRequestController extends GetxController {
  final playersRepo = PlayersRepository();
  final selectedPlayerLevel = RxnString();
  final selectedActivity = RxnString();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final notesController = TextEditingController();
  final requestTo = RxnString();
  Rx<XFile?> videoFile = Rx<XFile?>(null);

  final playerLevels = AppConstants.expertiseLevel;
  final activities = AppConstants.activities;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }

  void setPlayerLevel(String? level) {
    selectedPlayerLevel.value = level;
  }

  void setActivity(String? activity) {
    selectedActivity.value = activity;
  }

  Future<void> pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoFile.value = XFile(pickedFile.path);
    }
  }

  Future<String> convertVideoToBase64() async {
    if (videoFile.value == null) {
      return '';
    }
    final fileSize = await videoFile.value!.length();
    log('Video file size: $fileSize');

    final bytes = await videoFile.value!.readAsBytes();
    log('Video bytes: ${bytes.length}');
    final String base64String = base64Encode(bytes);
    log('BASE 64:${base64String.substring(0, 299)}');
    return base64String;
  }

  void submitRequest() async {
    if (selectedPlayerLevel.value == null ||
        selectedActivity.value == null ||
        selectedDate.value == null ||
        selectedTime.value == null) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Convert video to base64 if exists
    String base64Video = '';
    if (videoFile.value != null) {
      base64Video = await convertVideoToBase64();
    }

    // TODO: Add your API call here
    print('Submitting request with:');
    print('Player Level: ${selectedPlayerLevel.value}');
    print('Activity: ${selectedActivity.value}');
    print('Date: ${selectedDate.value}');
    print('Time: ${selectedTime.value}');
    print('Notes: ${notesController.text}');
    if (base64Video.isNotEmpty) {
      print('Video: data:video/mp4;base64,$base64Video');
    }
    final currentUserId =
        await PreferencesManager.getInstance().getStringValue('userId', '');
    final requestActivityBody = RequestActivityBody(
      reqFrom: currentUserId,
      reqTo: requestTo.value,
      activityId: selectedActivity.value,
      activityName: selectedActivity.value,
      activityLevel: selectedPlayerLevel.value,
      
    );
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
