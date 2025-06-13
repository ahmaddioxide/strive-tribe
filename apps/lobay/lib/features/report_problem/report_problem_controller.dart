import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/report_problem_body.dart';
import 'package:lobay/features/report_problem/report_problem_repo/report_problem_repo.dart';

class ReportProblemController extends GetxController {
  final ReportProblemRepo reportProblemRepo = ReportProblemRepo();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();

  RxBool isApiCalling = false.obs;

  Future<bool> reportProblem() async {
    try {
      isApiCalling.value = true;

      if (formKey.currentState!.validate()) {
        final body = ReportProblemBody(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          description: descriptionController.text.trim(),
        );

        final response = await reportProblemRepo.reportProblem(body);

        if (response != null && response.success) {
          await AppSnackbar.showSuccessSnackBar(
            message: response.message,
          );
          return true;
        } else {
          AppSnackbar.showErrorSnackBar(
            message: 'Failed to submit report',
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      AppSnackbar.showErrorSnackBar(
        message: 'An error occurred while submitting the report',
      );
      return false;
    } finally {
      isApiCalling.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
