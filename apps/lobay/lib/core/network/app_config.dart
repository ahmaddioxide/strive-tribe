import 'package:lobay/utilities/constants/app_enums.dart';

class AppConfig {
  static Environment environment = Environment.staging;

  static String get baseUrl {
    switch (environment) {
      case Environment.staging:
        return 'http://172.214.81.20:3000/';
      case Environment.prod:
        return '';
      case Environment.dev:
        return 'http://localhost:3000/';
    }
  }
}
