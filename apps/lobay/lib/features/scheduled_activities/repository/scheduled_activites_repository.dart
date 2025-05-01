import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/scheduled_activities_response_model.dart';

class ScheduledActivitiesRepo {
  final ApiClient _apiClient = ApiClient();

  Future<ScheduledActivitiesResponseModel?> getScheduledActivities(
      {required String userId,
      String? activities,
      String? playerLevels}) async {
    try {
      final response = await _apiClient.get(
          EndPoints.getScheduledActivities(
            userId: userId,
            activity: activities,
            playerLevel: playerLevels,
          ),
          retryCallback: () {});
      if (response != null &&
          (response.statusCode! >= 200 && response.statusCode! < 300)) {
        final data = response.data;
        if (data != null) {
          return ScheduledActivitiesResponseModel.fromJson(data);
        } else {
          print('No data found in the response');
        }
      } else {
        print('Error: ${response?.statusCode} - ${response?.statusMessage}');
      }
    } catch (e,stackTrace) {
      print('Error fetching scheduled activities: $e');
      print('Stack trace: $stackTrace');

    }
    return null;
  }
}
