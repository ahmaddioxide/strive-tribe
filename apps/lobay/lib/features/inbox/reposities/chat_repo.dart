import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/shared_preferences/shared_pref.dart';

import '../../../core/network/network_models/all_chats_reponse.dart';

class ChatRepo {
  final ApiClient _apiClient = ApiClient();

  Future<AllChatsResponse> getChats(
    String userId,
  ) async {
    final token =
        await PreferencesManager.getInstance().getStringValue('token', '');
    final response = await _apiClient
        .get(EndPoints.getChats(userId), retryCallback: () {}, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return AllChatsResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load chats');
    }
  }
}
