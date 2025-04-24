class RequestTimeoutConstants {
  static int durationFactor = 60; //default is 60 seconds, else fetched from BE

  ///timeouts for the network client
  static int connectTimeout = durationFactor * 1000; // 60 seconds
  static int receiveTimeout = durationFactor * 1000; // 60 seconds
  static int sendTimeout = durationFactor * 1000; // 60 seconds
}

class EndPoints {
  static const String register = 'api/auth/register';
  static const String login = 'api/auth/login';

  static checkUserExistance(String userId) =>
      'api/auth/checkuser?user_id=$userId';

  static getUser(String userId) => 'api/auth/getuser?user_id=$userId';

  static const String updateuser = 'api/auth/update';

  static const String createActivity = 'api/activities/create-activity';

  static getNotifications(String userId) =>
      'api/activities/notifications/$userId';

  static joinActivity({
    required String userId,
    required String activityId,
  }) =>
      'api/activities/join?userId=$userId&activityId=$activityId';

  static acceptParticipation({required String notificationId}) =>
      'api/activities/participation/$notificationId';

  static getActivities({
    required String userId,
    String? activityName,
    String? playerLevel,
  }) {
    final queryParams = {
      if (activityName != null) 'activityName': activityName,
      if (playerLevel != null) 'playerLevel': playerLevel,
    };
    if (queryParams.isNotEmpty) {
      return 'api/activities/nearby/$userId?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    }
    return 'api/activities/nearby/$userId';
  }

  //api/activities/activity-by-date-time?user_id=NRh76OzNtWaPcBMuWMuxjtN9WiW2&date=16-08-2023&time=09:30 PM

  static getActivityById({
    required String id,
  }) {
    return 'api/activities/activity-by-id/$id';
  }
}
