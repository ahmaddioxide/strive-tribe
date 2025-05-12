import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_click_widget.dart';
import 'package:lobay/features/players/controllers/activity_request_controller.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class RequestActivityScreen extends StatelessWidget with DeviceSizeUtil {
  const RequestActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityRequestController());
    final height = getDeviceHeight();
    final width = getDeviceWidth();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.07),
              AppClickWidget(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: width * 0.06,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Request Activity',
                style: TextUtils.getStyle(
                  color: AppColors.primaryLight,
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Add details to create activity.',
                style: TextUtils.getStyle(
                  color: AppColors.primaryLight,
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: height * 0.04),

              // Player Level Dropdown
              Text(
                'Player Level',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primaryLight.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedPlayerLevel.value,
                        dropdownColor: AppColors.white,
                        hint: Text('Select Player Level'),
                        items: controller.playerLevels.map((String level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: controller.setPlayerLevel,
                      ),
                    )),
              ),
              SizedBox(height: height * 0.03),

              // Activity Dropdown
              Text(
                'Activity Type',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primaryLight.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: AppColors.white,
                        value: controller.selectedActivity.value,
                        hint: Text('Select Activity'),
                        items: controller.activities.map((String activity) {
                          return DropdownMenuItem<String>(
                            value: activity,
                            child: Text(activity),
                          );
                        }).toList(),
                        onChanged: controller.setActivity,
                      ),
                    )),
              ),
              SizedBox(height: height * 0.03),

              // Date Selection
              Text(
                'Date',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.01),
              Obx(() => InkWell(
                    onTap: () => controller.selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryLight.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.selectedDate.value != null
                                ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                                : 'Select Date',
                            style: TextUtils.getStyle(
                              color: AppColors.black,
                              fontSize: width * 0.035,
                            ),
                          ),
                          Icon(Icons.calendar_today, size: width * 0.05),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: height * 0.03),

              // Time Selection
              Text(
                'Time',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.01),
              Obx(() => InkWell(
                    onTap: () => controller.selectTime(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryLight.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.selectedTime.value != null
                                ? controller.selectedTime.value!.format(context)
                                : 'Select Time',
                            style: TextUtils.getStyle(
                              color: AppColors.black,
                              fontSize: width * 0.035,
                            ),
                          ),
                          Icon(Icons.access_time, size: width * 0.05),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: height * 0.03),

              // Video Upload
              Text(
                'Video (Optional)',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.01),
              Obx(() => InkWell(
                    onTap: controller.pickVideo,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryLight.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.videoFile.value != null
                                ? controller.videoFile.value!.path
                                    .split('/')
                                    .last
                                : 'Upload Video',
                            style: TextUtils.getStyle(
                              color: AppColors.black,
                              fontSize: width * 0.035,
                            ),
                          ),
                          Icon(Icons.video_library, size: width * 0.05),
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: height * 0.03),

              // Notes
              Text(
                'Notes',
                style: TextUtils.getStyle(
                  color: AppColors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primaryLight.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller.notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter any additional notes...',
                    contentPadding: EdgeInsets.all(width * 0.04),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Request',
                    style: TextUtils.getStyle(
                      color: Colors.white,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
