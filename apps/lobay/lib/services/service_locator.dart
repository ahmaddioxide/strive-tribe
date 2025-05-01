import 'package:get/get.dart';
import 'package:lobay/services/notification_service.dart';

class ServiceLocator {
  static void init() {
    // Register services
    Get.put(NotificationService(), permanent: true);
  }
}
