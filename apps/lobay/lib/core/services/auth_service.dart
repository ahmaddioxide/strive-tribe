import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/repo/auth_repo.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

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
      print('signUpWithEmailAndPassword error: $e');
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
      print('signInWithEmailAndPassword error: $e');
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

      print('User signed in with Google: ${user?.email}');

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
      final ifUserAlreadyExists =
          await AuthenticationRepository().ifUserExists(userId!);

      if (ifUserAlreadyExists) {
        print('User already exists in the backend');
      } else {
        print('User does not exist in the backend');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    } catch (e) {
      print('signInWithGoogle error: $e');
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
        print('Facebook sign-in failed: ${result.status}');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    } catch (e) {
      print('signInWithFacebook error: $e');
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
      print('signOut error: $e');
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
        print('Auth Error: The email is invalid.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());
        break;
      case 'user-disabled':
        print('Auth Error: This user has been disabled.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'user-not-found':
        print('Auth Error: No user found for that email.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'wrong-password':
        print('Auth Error: Wrong password provided for that user.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'email-already-in-use':
        print('Auth Error: The email is already in use.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'operation-not-allowed':
        print(
            'Auth Error: Operation not allowed. Please enable it in Firebase.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      case 'weak-password':
        print('Auth Error: The password is too weak.');
        // AppSnackbar().showErrorSnackBar(message: e.message.toString());

        break;
      default:
        print('Auth Error: ${e.code} - ${e.message}');
      // AppSnackbar().showErrorSnackBar(message: e.message.toString());
    }
  }

  /// ---------------------------------------------
  /// SEND USER DATA TO BACKEND (OPTIONAL)
  /// ---------------------------------------------
  /// - If you want to store data in your own backend,
  ///   call this method after a successful sign-up or
  ///   first time sign-in (Google, Facebook).
  Future<void> _sendUserDataToBackend({
    required String uid,
    required String email,
    required String displayName,
    required String provider,
  }) async {
    // final Uri url = Uri.parse('https://YOUR_BACKEND_URL/api/users');
    //
    // // try {
    // //   final response = await http.post(
    // //     url,
    // //     headers: {'Content-Type': 'application/json'},
    // //     body: jsonEncode({
    // //       'uid': uid,
    // //       'email': email,
    // //       'displayName': displayName,
    // //       'provider': provider,
    // //     }),
    // //   );
    //
    //   if (response.statusCode != 200) {
    //     print('Failed to store user data in backend: ${response.statusCode}');
    //   } else {
    //     print('User data stored in backend successfully.');
    //   }
    // } catch (e) {
    //   print('Error sending user data to backend: $e');
    // }
  }
}
