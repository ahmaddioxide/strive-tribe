import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/login_body_model.dart';
import 'package:lobay/core/network/network_models/login_reponse_model.dart';
import 'package:lobay/services/auth_service.dart';
import 'package:lobay/services/shared_pref_service.dart';
import 'package:lobay/features/authentication/repository/auth_repo.dart';
import 'package:lobay/services/notification_service.dart';

import '../../bottom_navigation/bottom_navigation_main.dart';

class SignInController extends GetxController {
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  RxBool rememberMe = true.obs;
  RxBool isLoading = false.obs;

  Future<bool> signin() async {
    try {
      isLoading.value = true;
      final user = await AuthService().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (user != null) {
        // User signed in successfully with firebase

        final loginBody = LoginBodyModel(
          userId: user.uid,
        );
        final LoginResponseModel? response = await _authRepo.login(loginBody);
        if (response != null) {
          // Store user data in shared preferences
          await PreferencesManager.getInstance()
              .setStringValue('token', response.token);
          await PreferencesManager.getInstance()
              .setStringValue('userId', response.user.userId);
          await PreferencesManager.getInstance()
              .setStringValue('userName', response.user.name);
          await PreferencesManager.getInstance()
              .setStringValue('userEmail', response.user.email);

          // Initialize notifications
          await Get.find<NotificationService>().initialize();

          AppSnackbar.showSuccessSnackBar(message: 'Sign-in successful');

          // Add a small delay to ensure data is stored
          await Future.delayed(const Duration(milliseconds: 100));

          Get.offAll(() => BottomNavigationScreen());
          isLoading.value = false;
          return true;
        } else {
          AppSnackbar.showErrorSnackBar(message: 'Login failed');
          isLoading.value = false;
          return false;
        }
      } else {
        // Sign-in failed with firebase
        AppSnackbar.showErrorSnackBar(message: 'Sign-in failed');
        isLoading.value = false;
        return false;
      }
    } on FirebaseAuthException catch (e) {
      log('Sign-up error: $e');
      AppSnackbar.showErrorSnackBar(message: e.message.toString());
      isLoading.value = false;
      return false;
    }
  }

  Future<void> resetPassword() async {
    await AuthService().resetPassword(email: emailController.text);
  }
}
