import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/get_activities_body.dart';

class ActivityRepository {
  final ApiClient _apiClient = ApiClient();

  Future<GetActivitiesResponse?> getNearbyActivities({
    required String userId,
    String? activityName,
    String? playerLevel,
  }) async {
    try {
      final response = await _apiClient.get(
        EndPoints.getActivities(
          userId: userId,
          activityName: activityName,
          playerLevel: playerLevel,
        ),
        retryCallback: () {},
      );

      if (response.statusCode == 200) {
        return GetActivitiesResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch activities: ${response.statusMessage}');
      }
    } catch (e) {
      return null;
    }
  }
}
