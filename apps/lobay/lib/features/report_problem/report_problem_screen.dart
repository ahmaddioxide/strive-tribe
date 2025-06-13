import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/common_widgets/app_text_field.dart';
import 'package:lobay/features/report_problem/report_problem_controller.dart';
import 'package:lobay/utilities/app_utils/validators.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class ReportProblemScreen extends StatelessWidget with DeviceSizeUtil {
  const ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportProblemController());
    final width = getDeviceWidth();
    final height = getDeviceHeight();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report a Problem',
          style: TextUtils.getStyle(
            color: AppColors.primaryLight,
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.02),
                Text(
                  'Help us improve',
                  style: TextUtils.getStyle(
                    color: AppColors.primaryLight,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.006),
                Text(
                  'Please describe the problem you\'re experiencing.',
                  style: TextUtils.getStyle(
                    color: AppColors.primaryLight,
                    fontSize: width * 0.035,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Name',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppTextField(
                  hintText: 'Enter your name',
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  validator: Validator.validateName,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Email',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                AppTextField(
                  hintText: 'Enter your email',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateEmail,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Description',
                  style: TextUtils.getStyle(
                    fontSize: width * 0.034,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: height * 0.006),
                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Describe your problem',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.03),
                Obx(() {
                  return AppButton(
                    isLoading: controller.isApiCalling.value,
                    buttonText: 'Submit',
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (controller.formKey.currentState!.validate()) {
                        final success = await controller.reportProblem();
                        if (success) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  );
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
