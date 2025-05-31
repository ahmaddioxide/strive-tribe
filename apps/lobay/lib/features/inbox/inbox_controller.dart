import 'dart:developer' show log;

import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/all_chats_reponse.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';
import 'package:lobay/features/inbox/reposities/chat_repo.dart';
import 'package:lobay/services/socket_service.dart';

class InboxController extends GetxController {
  final ChatRepo chatRepo = ChatRepo();
  final SocketService socketService = SocketService();

  final Rx<AllChatsResponse?> allChatsResponse = Rx<AllChatsResponse?>(null);
  final RxBool isLoading = RxBool(false);
  final RxList<Map<String, dynamic>> chatRooms = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    try {
      isLoading.value = true;
      await socketService.initialize();
      socketService.connect();

      // Wait for connection to establish
      await Future.delayed(const Duration(seconds: 1));
      socketService.getAllRooms();
    } catch (e) {
      AppSnackbar.showErrorSnackBar(message: 'Failed to initialize chat');
    } finally {
      isLoading.value = false;
    }
  }

  void _setupSocketListeners() {
    log('chatRooms called on inbox controller');
    socketService.on('chatRooms', (data) {
      log('chatRooms received in inbox controller: $data');
      try {
        final rooms = data['rooms'] as List;
        final updatedRooms = rooms.whereType<Map<String, dynamic>>().toList();
        log('Processing ${updatedRooms.length} rooms');

        // Update the chat rooms list
        chatRooms.clear();
        chatRooms.addAll(updatedRooms);

        // Force UI update
        chatRooms.refresh();
        log('Updated chat rooms: ${chatRooms.length} rooms');
      } catch (e, stackTrace) {
        log('Error updating chat rooms: $e');
        log('Stack trace: $stackTrace');
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _setupSocketListeners();
  }

  // Future<void> getChats() async {
  //   final userId =
  //       await PreferencesManager.getInstance().getStringValue('userId', '');
  //   if (userId == null) {
  //     return;
  //   }
  //   try {
  //     isLoading.value = true;
  //     final response = await chatRepo.getChats(userId);
  //     if (response.success) {
  //       allChatsResponse.value = response;
  //     } else {
  //       AppSnackbar.showErrorSnackBar(message: 'Failed to load chats ');
  //     }
  //   } catch (e) {
  //     AppSnackbar.showErrorSnackBar(message: 'Failed to load chats');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }
}
