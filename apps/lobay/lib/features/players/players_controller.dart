import 'package:get/get.dart';
import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/network_models/get_nearby_players_response_model.dart';
import 'package:lobay/core/network/network_models/get_user_reponse_body.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';
import 'package:lobay/features/players/repo/players_repo.dart';
import 'package:lobay/features/profile/repository/profile_repo.dart';
import 'package:lobay/utilities/commom_models/pairs_model.dart';
import 'package:lobay/utilities/constants/app_constants.dart';

class PlayersController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<UserModel?> userDetails = Rx<UserModel?>(null);
  final Rx<GetNearbyPlayersResponseModel?> nearbyPlayersRes =
      Rx<GetNearbyPlayersResponseModel?>(null);
  final ProfileRepo profileRepo = ProfileRepo();
  final PlayersRepository playersRepo = PlayersRepository();
  final RxBool isLoading = true.obs;
  final RxBool isLoadingUserDetails = false.obs;

  final RxList<Pair<String, RxBool>> activities = <Pair<String, RxBool>>[
    Pair(AppConstants.activities[0], false.obs),
    Pair(AppConstants.activities[1], false.obs),
    Pair(AppConstants.activities[2], false.obs),
    Pair(AppConstants.activities[3], false.obs),
    Pair(AppConstants.activities[4], false.obs),
    Pair(AppConstants.activities[5], false.obs),
  ].obs;

  final RxList<String> selectedActivities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
    getNearbyPlayer();
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

  Future<void> fetchUserDetails(String userId) async {
    isLoadingUserDetails.value = true;
    try {
      userDetails.value = await profileRepo.getUser(userId: userId);
    } catch (e) {
      AppSnackbar.showErrorSnackBar(message: 'Failed to fetch user details');
      print('Error fetching user details: $e');
      userDetails.value = null;
    } finally {
      isLoadingUserDetails.value = false;
    }
  }

  Future<void> getNearbyPlayer() async {
    isLoading.value = true;
    final userId =
        await PreferencesManager.getInstance().getStringValue('userId', '');

    try {
      nearbyPlayersRes.value = await playersRepo.getPlayers(
        userId: userId!,
        selectedActivity:
            selectedActivities.isNotEmpty ? selectedActivities.join(',') : null,
      );

      if (nearbyPlayersRes.value == null) {
        AppSnackbar.showErrorSnackBar(message: 'No players found');
      } else {
        AppSnackbar.showSuccessSnackBar(
            message: 'Players fetched successfully');
      }
    } catch (e) {
      AppSnackbar.showErrorSnackBar(message: 'Failed to fetch players');
      print('Error fetching players: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleActivitySelection(Pair<String, RxBool> activity) {
    activity.second.value = !activity.second.value;
    if (activity.second.value) {
      selectedActivities.add(activity.first);
    } else {
      selectedActivities.remove(activity.first);
    }
  }

  void resetFilter() {
    for (final activity in activities) {
      activity.second.value = false;
    }
    selectedActivities.clear();
    getNearbyPlayer();
  }
}
