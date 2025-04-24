import 'dart:developer';

import 'package:get/get.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';

import 'repository/notification_repo.dart';

class NotificationsController extends GetxController {
  final _notificationRepo = NotificationRepository();
  RxBool isLoading = false.obs;
  RxList notifications = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    isLoading.value = true;
    try {
      final userId =
          await PreferencesManager.getInstance().getStringValue('userId', '');

      if (userId == null || userId.isEmpty) {
        log('User ID is null or empty');
        return;
      }
      // Simulate a network call
      final response = await _notificationRepo.getNotifications(
        userId: userId,
      );

      // Fetch notifications from the server or local storage
      notifications.value = [
        'Notification 1',
        'Notification 2',
        'Notification 3',
      ];
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
