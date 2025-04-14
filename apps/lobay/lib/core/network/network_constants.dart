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

  static const String updateuser= 'api/auth/update';

  static const String createActivity = 'api/activities/create-activity';
}
