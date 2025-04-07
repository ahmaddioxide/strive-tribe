import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';

class AuthenticationRepository {
  // This class will handle authentication-related tasks
  // such as login, logout, and user session management.

  final apiClient = ApiClient();

  Future<bool> ifUserExists(String userId) async {
    // Check if the user exists in the local storage

    final response = await apiClient.get(
      EndPoints.userExists(userId),
      retryCallback: () {},
      data: {
        'user_id': userId,
      },
    );
    if (response.statusCode == 200) {
      final responseData = response.data;
      final Map<String, dynamic> responseMap =
          responseData as Map<String, dynamic>;
      // Check if the user exists
      if (responseMap['exists'] == true) {
        // User exists
        return true;
      } else {
        // User does not exist
        return false;
      }
      return true;
    } else {
      // Handle error
      return false;
    }
  }
}
