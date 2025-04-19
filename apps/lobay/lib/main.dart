import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/services/service_locator.dart';
import 'package:lobay/features/activity_details/activity_details_screen.dart';
import 'package:lobay/features/bottom_navigation/bottom_navigation_main.dart';
import 'package:lobay/features/onboarding/onboarding_screen.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/theme_utils/app_theme.dart';

import 'services/shared_pref_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // debugRepaintRainbowEnabled = false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  ServiceLocator.init();

  final String token =
      await PreferencesManager.getInstance().getStringValue('token', '');
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(
        token: token,
      ), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  final String token;

  const MyApp({
    super.key,
    required this.token,
  });

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: token.isEmpty ? OnboardingScreen() : BottomNavigationScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              final baseClient = ApiClient();
              baseClient.post(
                EndPoints.login,
                data: {"user_id": "QRh76OzNtWaPcBMuWMuxjtN9WiW2"},
                retryCallback: () {},
              );
            },
            child: Text('Test'),
          ),
        ],
      ),
    );
  }
}
