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

  static userExists(String userId) => 'api/auth/checkuser';

}
