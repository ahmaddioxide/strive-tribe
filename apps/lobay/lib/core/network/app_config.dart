import 'package:lobay/utilities/constants/app_enums.dart';

class AppConfig {
  static Environment environment = Environment.staging;

  static String get baseUrl {
    switch (environment) {
      case Environment.staging:
        return 'https://strive-tribe-sports.vercel.app/';
      case Environment.prod:
        return '';
      case Environment.dev:
        return 'http://localhost:3000/';
    }
  }
}
