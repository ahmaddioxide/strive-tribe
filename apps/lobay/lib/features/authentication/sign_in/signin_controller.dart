import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/login_body_model.dart';
import 'package:lobay/core/network/network_models/login_reponse_model.dart';
import 'package:lobay/core/services/auth_service.dart';
import 'package:lobay/core/services/shared_pref_service.dart';
import 'package:lobay/features/authentication/repository/auth_repo.dart';

import '../../bottom_navigation/bottom_navigation_main.dart';

class SignInController extends GetxController {
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  RxBool rememberMe = false.obs;

  Future<bool> signin() async {
    try {
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
              .setStringValue('userId', response.user.id);
          await PreferencesManager.getInstance()
              .setStringValue('userName', response.user.name);
          await PreferencesManager.getInstance()
              .setStringValue('userEmail', response.user.email);
          AppSnackbar.showSuccessSnackBar(message: 'Sign-in successful');
          Get.offAll(() => BottomNavigationScreen());
          return true;
        } else {
          AppSnackbar.showErrorSnackBar(message: 'Login failed');
          return false;
        }
      } else {
        // Sign-in failed with firebase
        AppSnackbar.showErrorSnackBar(message: 'Sign-in failed');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      log('Sign-up error: $e');
      AppSnackbar.showErrorSnackBar(message: e.message.toString());
      return false;
    }
  }
}
