import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class CreateActivityController extends GetxController {
  RxString selectedActivity = 'Badminton'.obs;
  RxString selectedPlayerLevel = 'Beginner'.obs;
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Rx<XFile?> videoFile = Rx<XFile?>(null);

  final formKey = GlobalKey<FormState>();

  void showDatePickerAdaptive(BuildContext context) {
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
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    dateController.text =
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
    }
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
                    timeController.text = newTime
                        .toLocal()
                        .toString()
                        .split(' ')[1]
                        .substring(0, 5);
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
}
