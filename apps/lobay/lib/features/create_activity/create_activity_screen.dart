import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/common_widgets/app_drop_down.dart';
import 'package:lobay/common_widgets/app_text_field.dart';
import 'package:lobay/features/create_activity/create_activity_controller.dart';
import 'package:lobay/utilities/app_utils/validators.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class CreateActivityScreen extends StatelessWidget with DeviceSizeUtil {
  const CreateActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    final controller = Get.put(CreateActivityController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryLight),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // title: const Text('Create Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Activity',
                  style: TextUtils.getStyle(
                    color: AppColors.primaryLight,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.006),
                Text(
                  'Add details to create activity.',
                  style: TextUtils.getStyle(
                    color: AppColors.primaryLight,
                    fontSize: width * 0.035,
                    // fontWeight: FontWeight./,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Activity',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppDropDown(
                  options: AppConstants.activities,
                  hint: 'Select Activity',
                  selectedValue: controller.selectedActivity,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Player level',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppDropDown(
                  options: AppConstants.expertiseLevel,
                  hint: 'Select opponent rating',
                  selectedValue: controller.selectedPlayerLevel,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Select date',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppTextField(
                  hintText: 'Select Date',
                  controller: controller.dateController,
                  keyboardType: TextInputType.datetime,
                  // enabled: false,/
                  readOnly: true,
                  trailingIcon: Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.grey,
                  ),
                  onTap: () {
                    controller.showDatePickerAdaptive(context);
                  },
                  validator: Validator.validateDateOfBirth,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Select time',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppTextField(
                  hintText: 'Select time',
                  controller: controller.timeController,
                  keyboardType: TextInputType.datetime,
                  // enabled: false,/
                  readOnly: true,
                  trailingIcon: Icon(
                    Icons.access_time_outlined,
                    color: AppColors.grey,
                  ),
                  onTap: () {
                    controller.showTimePickerAdaptive(context);
                  },
                  validator: Validator.validateTime,
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    Text(
                      'Upload video',
                      style: TextUtils.getStyle(
                        fontSize: width * 0.034,
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      ' (Optional)',
                      style: TextUtils.getStyle(
                        fontSize: width * 0.034,
                        color: AppColors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.006),
                Obx(() {
                  return Row(
                    children: [
                      controller.videoFile.value == null
                          ? Container(
                              height: height * 0.04,
                              width: height * 0.04,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColors.white,
                                size: height * 0.04,
                              ),
                            )
                          : Container(
                              height: height * 0.04,
                              width: height * 0.04,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: height * 0.04,
                              ),
                            ),
                      SizedBox(width: width * 0.02),
                      AppClickWidget(
                        onTap: () async {
                          await controller.pickVideo();
                        },
                        child: Text(
                          controller.videoFile.value == null
                              ? 'Upload video'
                              : 'Change video file',
                          style: TextUtils.getStyle(
                            fontSize: width * 0.034,
                            color: AppColors.primaryLight,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: height * 0.02),
                Text(
                  'Notes',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                TextFormField(
                  maxLines: 3,
                  controller: controller.notesController,
                  decoration: InputDecoration(
                    hintText: 'Add notes',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: width * 0.034,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Obx(() {
                  return AppButton(
                      isLoading: controller.isApiCalling.value,
                      buttonText: 'Create',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        controller.isApiCalling.value = true;
                        if (controller.formKey.currentState!.validate()) {
                          final isCrated = await controller.createActivity();
                          if (isCrated) {
                            Get.back();
                          } else {
                            print('Activity creation failed');
                          }
                        } else {
                          print('Validation failed');
                        }
                        controller.isApiCalling.value = false;
                      });
                }),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
