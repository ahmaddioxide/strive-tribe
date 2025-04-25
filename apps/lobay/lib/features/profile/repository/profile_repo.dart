import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/get_user_reponse_body.dart';

class ProfileRepo {
  final ApiClient _apiClient = ApiClient();

  //get user

  Future<UserModel?> getUser({required final String userId}) async {
    try {
      final response = await _apiClient.get(
        EndPoints.getUser(userId),
        retryCallback: () {},
      );
      if (response.statusCode == 200) {
        // Handle successful login
        final getUserResponse = UserModel.fromJson(response.data);
        return getUserResponse;
      } else {
        // Handle error response
        throw Exception('Failed to fetch data: ${response.statusMessage}');
      }
    } on Exception {
      // Handle exceptions
      return null;
    }
  }

  Future<bool> updateUser({required Map<String, dynamic> data}) async {
    try {
      final response = await _apiClient.put(
        EndPoints.updateuser,
        data: data,
        retryCallback: () {},
      );
      if (response.statusCode == 200) {
        // Handle successful login
        return true;
      } else {
        // Handle error response
        throw Exception('Failed to put data: ${response.statusMessage}');
      }
    } on Exception {
      // Handle exceptions
      return false;
    }
  }
}
