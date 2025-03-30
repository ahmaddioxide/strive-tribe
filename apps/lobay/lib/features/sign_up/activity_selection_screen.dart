import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_button.dart';
import 'package:lobay/features/sign_up/signup_controller.dart';
import 'package:lobay/features/sign_up/widgets/activity_container.dart';
import 'package:lobay/features/sign_up/widgets/select_activity_top_bar.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';

class ActivitySelectionScreen extends StatelessWidget with DeviceSizeUtil {
  const ActivitySelectionScreen({super.key});

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Obx(() {
              return AppButton(
                isEnabled: signupController.selectedActivities.isNotEmpty,
                buttonText: 'Register',
                onPressed: () async {
                  if (signupController.formKey.currentState!.validate()) {
                    await signupController.signup();
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
