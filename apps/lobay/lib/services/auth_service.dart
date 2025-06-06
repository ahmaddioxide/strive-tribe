import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/login_body_model.dart';
import 'package:lobay/core/network/network_models/login_reponse_model.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';
import 'package:lobay/features/authentication/repository/auth_repo.dart';
import 'package:lobay/features/authentication/sign_up/signup_screen.dart';
import 'package:lobay/features/bottom_navigation/bottom_navigation_main.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  /// ---------------------------------------------
  /// SIGN UP WITH EMAIL & PASSWORD
  /// ---------------------------------------------
  /// - Creates a new user in Firebase
  /// - Calls optional backend to store user data
  /// - Returns the [User], or throws an error
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors with dedicated function
      _handleAuthError(e);
      rethrow;
    } catch (e) {
      // Unexpected errors
      rethrow;
    }
  }

  /// ---------------------------------------------
  /// SIGN IN WITH EMAIL & PASSWORD
  /// ---------------------------------------------
  /// - Signs in with Firebase using email/password
  /// - Returns the [User], or throws an error
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('signInWithEmailAndPassword error: $e');
      }
      rethrow;
    }
  }

  /// ---------------------------------------------
  /// SIGN IN WITH GOOGLE
  /// ---------------------------------------------
  /// - Uses GoogleSignIn for OAuth
  /// - Gets Firebase credential from Google ID token
  /// - If new user, optionally call backend with user data
  /// - Returns the [User], or throws an error
  Future<User?> signInWithGoogle() async {
    // await signOut();
    try {
      // Trigger Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Operation canceled by user

        return null;
      }

      // Obtain auth details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in on Firebase with this credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;


      // If it's a new user, optionally store data in backend
      // if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      //   await _sendUserDataToBackend(
      //     uid: user?.uid ?? '',
      //     email: user?.email ?? '',
      //     displayName: user?.displayName ?? '',
      //     provider: 'google',
      //   );
      // }

      final userId = user?.uid;
      //check if user exists in the backend
      final ifUserAlreadyExists = await _authRepo.ifUserExists(userId!);

      if (ifUserAlreadyExists) {
        log('User already exists in the backend');
        final loginBody = LoginBodyModel(
          userId: userId,
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
          AppSnackbar.showSuccessSnackBar(message: 'Sign-in successful');
          Get.offAll(() => BottomNavigationScreen());
        }
      } else {
        Get.offAll(SignupScreen(
          isGoogleLogin: true,
        ));
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// ---------------------------------------------
  /// SIGN IN WITH FACEBOOK
  /// ---------------------------------------------
  /// - Uses FacebookAuth for OAuth
  /// - Gets Firebase credential from Facebook
  /// - If new user, optionally call backend with user data
  /// - Returns the [User], or throws an error
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();

      if (result.status == LoginStatus.success) {
        // Obtain the auth token from the result
        final AccessToken? accessToken = result.accessToken;
        if (accessToken == null) {
          return null;
        }

        // Create a credential for Firebase
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in on Firebase with this credential
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        // If it's a new user, optionally store data in backend
        // if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        //   await _sendUserDataToBackend(
        //     uid: user?.uid ?? '',
        //     email: user?.email ?? '',
        //     displayName: user?.displayName ?? '',
        //     provider: 'facebook',
        //   );
        // }

        return user;
      } else {
        // Facebook login failed or canceled
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// ---------------------------------------------
  /// SIGN OUT
  /// ---------------------------------------------
  /// - Signs the user out from all Firebase providers
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _facebookAuth.logOut();
    } catch (e) {
      rethrow;
    }
  }

  /// ---------------------------------------------
  /// GET CURRENT USER
  /// ---------------------------------------------
  /// - Returns the currently signed-in [User], or null if none
  User? get currentUser => _firebaseAuth.currentUser;

  /// ---------------------------------------------
  /// HANDLE COMMON FIREBASE AUTH ERRORS
  /// ---------------------------------------------
  /// - Converts FirebaseAuthException codes to
  ///   messages/logs (you can also show UI messages).
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());
        break;
      case 'user-disabled':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'user-not-found':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'wrong-password':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'email-already-in-use':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'operation-not-allowed':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'weak-password':
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      default:
      // AppSnackbar().showErrorSnackBar(message: e.message.toString());
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppSnackbar.showSuccessSnackBar(
          message: 'Password reset email sent, please check your inbox');
    } on FirebaseAuthException catch (e) {
      log('Reset password error: $e');
      AppSnackbar.showErrorSnackBar(message: e.message.toString());
    }
  }
}
