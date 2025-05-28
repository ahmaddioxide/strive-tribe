import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/all_chats_reponse.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';
import 'package:lobay/features/inbox/reposities/chat_repo.dart';

class InboxController extends GetxController {
  final ChatRepo chatRepo = ChatRepo();

  final Rx<AllChatsResponse?> allChatsResponse = Rx<AllChatsResponse?>(null);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getChats();
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
