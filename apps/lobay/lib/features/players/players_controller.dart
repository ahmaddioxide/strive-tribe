import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/get_user_reponse_body.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';
import 'package:lobay/features/profile/repository/profile_repo.dart';

class PlayersController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final ProfileRepo profileRepo = ProfileRepo();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    isLoading.value = true;
    final userId =
        await PreferencesManager.getInstance().getStringValue('userId', '');
    try {
      user.value = await profileRepo.getUser(userId: userId!);
    } catch (e) {
      AppSnackbar.showErrorSnackBar(message: 'Failed to fetch user data');
      print('Error fetching user data: $e');
      user.value = null; // Set user to null in case of error
    } finally {
      isLoading.value = false;
    }
  }
}
