import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';

class NotificationRepository {
  final _apiClient = ApiClient();



  Future<dynamic> getNotifications({required String userId})async{
    try {
      final response = await _apiClient.get(
        EndPoints.getNotifications(userId),
        retryCallback: (){},
      );
      if (response == null) {
        throw Exception('No response from server');
      }
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load notifications');
      }
     ///
    } catch (e) {
      rethrow;
    }
  }


}