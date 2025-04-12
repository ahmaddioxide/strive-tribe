import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/login_body_model.dart';
import 'package:lobay/core/network/network_models/login_reponse_model.dart';
import 'package:lobay/core/network/network_models/register_body_model.dart';
import 'package:lobay/core/network/network_models/register_response_body.dart';
import 'package:lobay/core/services/shared_pref_service.dart';

class AuthenticationRepository {
  // This class will handle authentication-related tasks
  // such as login, logout, and user session management.
  final ApiClient apiClient = ApiClient();

  Future<LoginResponseModel?> login(LoginBodyModel loginBody) async {
    try {
      final response = await apiClient.post(
        EndPoints.login,
        data: loginBody.toJson(),
        retryCallback: () {},
      );
      if (response.statusCode == 200) {
        // Handle successful login
        final loginResponse = LoginResponseModel.fromJson(response.data);
        return loginResponse;
      } else {
        // Handle error response
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } on Exception catch (e) {
      // Handle exceptions
      AppSnackbar.showErrorSnackBar(message: e.toString());
      return null;
    }
  }

  Future<RegisterResponseBody?> register(RegisterBodyModel registerBody) async {
    try {
      final response = await apiClient.post(
        EndPoints.register,
        data: registerBody.toJson(),
        retryCallback: () {},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Handle successful registration
        final registerResponse = RegisterResponseBody.fromJson(response.data);
        return registerResponse;
      } else {
        // Handle error response
        throw Exception('Failed to register: ${response.statusMessage}');
      }
    } on Exception catch (e) {
      // Handle exceptions
      AppSnackbar.showErrorSnackBar(message: e.toString());
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      //google sign out
      await GoogleSignIn().signOut();

      await PreferencesManager.getInstance().clearAllPref();

      // Handle successful logout
    } on Exception catch (e) {
      // Handle exceptions
      AppSnackbar.showErrorSnackBar(message: e.toString());
    }
  }

  Future<bool> ifUserExists(String userId) async {
    // Check if the user exists in the local storage

    final response = await apiClient.get(
      EndPoints.checkUserExistance(userId),
      retryCallback: () {},
    );
    if (response.statusCode == 200) {
      final responseData = response.data;
      final Map<String, dynamic> responseMap =
      responseData as Map<String, dynamic>;
      // Check if the user exists
      if (responseMap['exists'] == true) {
        // User exists
        return true;
      } else {
        // User does not exist
        return false;
      }
      return true;
    } else {
      // Handle error

      return false;
    }
  }
}
