import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/features/authentication/sign_up/signup_controller.dart';
import 'package:lobay/features/authentication/sign_up/widgets/activity_container.dart';
import 'package:lobay/features/authentication/sign_up/widgets/select_activity_top_bar.dart';

import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class ActivitySelectionScreen extends StatelessWidget with DeviceSizeUtil {
  final bool isGoogleLogin;

  const ActivitySelectionScreen({super.key, this.isGoogleLogin = false});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();
    final height = getDeviceHeight();
    final width = getDeviceWidth();
    return Scaffold(
      body: Column(
        children: [
          SelectActivityTopBar(),
          SizedBox(height: height * 0.02),
          Obx(() {
            return Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: width * 0.02,
                  mainAxisSpacing: height * 0.02,
                  childAspectRatio: 4 / 4,
                ),
                itemCount: signupController.activities.length,
                itemBuilder: (context, index) {
                  return ActivityContainer(
                    index: index,
                  );
                },
              ),
            );
          }),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            '*Note: More activities will be added soon',
            style: TextStyle(color: AppColors.grey, fontSize: 12),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Obx(() {
              return AppButton(
                isLoading: signupController.isApiCalling.value,
                isEnabled: signupController.selectedActivities.isNotEmpty,
                buttonText: 'Register',
                onPressed: () async {
                  if (signupController.formKey.currentState!.validate()) {
                    signupController.isApiCalling.value = true;
                    if (isGoogleLogin) {
                      await signupController.signupWithGoogle();
                      signupController.isApiCalling.value = false;
                      return;
                    } else {
                      // Call the signup method
                      signupController.isApiCalling.value = true;
                      await signupController.signup();
                      signupController.isApiCalling.value = false;
                      return;
                    }
                  }
                },
              );
            }),
          ),
          SizedBox(
            height: height * 0.03,
          )
        ],
      ),
    );
  }
}
