import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/features/bottom_navigation/bottom_navigation_main.dart';
import 'package:lobay/features/onboarding/onboarding_screen.dart';
import 'package:lobay/utilities/constants/app_constants.dart';
import 'package:lobay/utilities/theme_utils/app_theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // debugRepaintRainbowEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: FirebaseAuth.instance.currentUser == null
          ?  OnboardingScreen()
          :  BottomNavigationScreen(),
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
