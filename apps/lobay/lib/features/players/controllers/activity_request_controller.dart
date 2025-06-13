import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/request_activity_body.dart';
import 'package:lobay/features/players/repo/players_repo.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';

class ActivityRequestController extends GetxController {
  final playersRepo = PlayersRepository();
  final selectedPlayerLevel = RxnString();
  final selectedActivity = RxnString();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();
  final notesController = TextEditingController();
  Rx<XFile?> videoFile = Rx<XFile?>(null);
  final RxString selectedPlayerId = RxString('');

  final playerLevels = AppConstants.expertiseLevel;
  final activities = AppConstants.activities;

  // Computed property to check if all mandatory fields are filled
  bool get isFormValid =>
      selectedPlayerLevel.value != null &&
      selectedActivity.value != null &&
      selectedDate.value != null &&
      selectedTime.value != null;

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

    final currentUserId =
        await PreferencesManager.getInstance().getStringValue('userId', '') ??
            '';

    final selectedDateString =
        DateFormat('dd-MM-yyyy').format(selectedDate.value!);
    final selectedTimeString = DateFormat('hh:mm a').format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      selectedTime.value!.hour,
      selectedTime.value!.minute,
    ));

    final requestActivityBody = RequestActivityBody(
      reqFrom: currentUserId,
      reqTo: selectedPlayerId.value,
      activityName: selectedActivity.value!,
      activityLevel: selectedPlayerLevel.value!,
      activityDate: selectedDateString,
      activityTime: selectedTimeString,
      note:
          notesController.text.trim().isNotEmpty ? notesController.text : null,
      video:
          base64Video.isNotEmpty ? 'data:video/mp4;base64,$base64Video' : null,
    );

    try {
      final response = await playersRepo.requestActivity(requestActivityBody);
      // final requestResponse  RequestActivityResponse.fromJson(response);

      if (response) {
        Get.back();
        AppSnackbar.showSuccessSnackBar(message: 'Request Sent');
      } else {
        // AppSnackbar.showErrorSnackBar(message: 'Failed to send request');
      }
    } catch (e) {
      log('Failed to send request: $e');
      // AppSnackbar.showErrorSnackBar(message: 'Failed to send request');
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
