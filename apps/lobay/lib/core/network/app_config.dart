import 'package:lobay/utilities/constants/app_enums.dart';

class AppConfig {
  static Environment environment = Environment.dev; // Change this as needed

  static String get baseUrl {
    switch (environment) {
      case Environment.staging:
        return '';
      case Environment.prod:
        return '';
      case Environment.dev:
        return '';
    }
  }
}
