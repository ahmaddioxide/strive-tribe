import 'package:get/get.dart';
import 'package:lobay/utilities/commom_models/pairs_model.dart';
import 'package:lobay/utilities/constants/app_constants.dart';

class HomeScreenController extends GetxController {
  final RxList<Pair<String, RxBool>> activities = <Pair<String, RxBool>>[
    Pair(AppConstants.activities[0], false.obs),
    Pair(AppConstants.activities[1], false.obs),
    Pair(AppConstants.activities[2], false.obs),
    Pair(AppConstants.activities[3], false.obs),
    Pair(AppConstants.activities[4], false.obs),
    Pair(AppConstants.activities[5], false.obs),
  ].obs;
  final RxList<Pair<String, RxBool>> playerLevel = <Pair<String, RxBool>>[
    Pair(AppConstants.expertiseLevel[0], false.obs),
    Pair(AppConstants.expertiseLevel[1], false.obs),
    Pair(AppConstants.expertiseLevel[2], false.obs),
  ].obs;

  final RxList<String> selectedActivities = <String>[].obs;
  final RxList<String> selectedPlayerLevel = <String>[].obs;

  void toggleActivitySelection(Pair<String, RxBool> activity) {
    activity.second.value = !activity.second.value;
    if (activity.second.value) {
      selectedActivities.add(activity.first);
    } else {
      selectedActivities.remove(activity.first);
    }
  }

  void togglePlayerLevelSelection(Pair<String, RxBool> level) {
    level.second.value = !level.second.value;
    if (level.second.value) {
      selectedPlayerLevel.add(level.first);
    } else {
      selectedPlayerLevel.remove(level.first);
    }
  }

  void resetFilter() {
    for (final activity in activities) {
      activity.second.value = false;
    }
    for (final level in playerLevel) {
      level.second.value = false;
    }
    selectedActivities.clear();
    selectedPlayerLevel.clear();
  }
}
