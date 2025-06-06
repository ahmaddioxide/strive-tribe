import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/get_activities_body.dart';
import 'package:lobay/core/network/network_models/get_activity_by_date_time.dart';
import 'package:lobay/core/network/network_models/join_activity_response_model.dart';

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

  Future<GetActivityByDateTimeResponse> getActivityById({
    required String id,
  }) async {
    try {
      final response = await _apiClient.get(
        EndPoints.getActivityById(
          id: id,
        ),
        retryCallback: () {},
      );

      if (response.statusCode == 200) {
        return GetActivityByDateTimeResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch activities: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<JoinActivityResponseModel> joinActivity(
      {required String userId, required String activityId}) async {
    try {
      final response = await _apiClient.post(
        EndPoints.joinActivity(
          userId: userId,
          activityId: activityId,
        ),
        retryCallback: () {},
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return JoinActivityResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            '${response.data['error']}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
