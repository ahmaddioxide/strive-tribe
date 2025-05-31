import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/all_chats_reponse.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';
import 'package:lobay/features/inbox/reposities/chat_repo.dart';
import 'package:lobay/services/socket_service.dart';

class InboxController extends GetxController {
  final ChatRepo chatRepo = ChatRepo();

  final Rx<AllChatsResponse?> allChatsResponse = Rx<AllChatsResponse?>(null);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // getChats();

    // Initialize the service
    final socketService = SocketService();
    await socketService.initialize();

    // Connect to the socket
    socketService.connect();
    Future.delayed(const Duration(seconds: 1), () {
      socketService.getAllChat('aa5vQ2sht3gblxv2EgLDOJjcHr92');
    });
  }

  Future<void> getChats() async {
    final userId =
        await PreferencesManager.getInstance().getStringValue('userId', '');
    if (userId == null) {
      return;
    }
    try {
      isLoading.value = true;
      final response = await chatRepo.getChats(userId);
      if (response.success) {
        allChatsResponse.value = response;
      } else {
        AppSnackbar.showErrorSnackBar(message: 'Failed to load chats ');
      }
    } catch (e) {
      AppSnackbar.showErrorSnackBar(message: 'Failed to load chats');
    } finally {
      isLoading.value = false;
    }
  }
}
