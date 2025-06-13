import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/features/terms_and_policy/terms_and_policy_screen_controller.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:markdown_widget/markdown_widget.dart';

class TermsAndPolicyScreen extends StatelessWidget with DeviceSizeUtil {
  const TermsAndPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsAndPolicyScreenController());
    final width = getDeviceWidth();
    final height = getDeviceHeight();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms and Policy',
          style: TextUtils.getStyle(
            color: AppColors.primaryLight,
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: TextUtils.getStyle(
                    color: AppColors.grey,
                    fontSize: width * 0.04,
                  ),
                ),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: controller.fetchTermsAndPolicy,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.termsAndPolicy.value == null) {
          return const Center(
            child: Text('No terms and policy available'),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version ${controller.termsAndPolicy.value!.terms.version}',
                style: TextUtils.getStyle(
                  color: AppColors.grey,
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Effective Date: ${controller.termsAndPolicy.value!.terms.effectiveDate.toString().split(' ')[0]}',
                style: TextUtils.getStyle(
                  color: AppColors.grey,
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(height: height * 0.02),
              MarkdownWidget(
                data: controller.termsAndPolicy.value!.terms.content,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
