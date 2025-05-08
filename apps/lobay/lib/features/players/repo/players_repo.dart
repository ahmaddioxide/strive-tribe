import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/get_nearby_players_response_model.dart';

class PlayersRepository {
  final ApiClient _apiClient = ApiClient();

  Future<GetNearbyPlayersResponseModel?> getPlayers(
      {required String userId, String? selectedActivity}) async {
    try {
      final response = await _apiClient.get(
          EndPoints.getPlayers(selectedActivity, userId),
          retryCallback: () {});

      if (response.statusCode != 200) {
        throw Exception('Failed to load players');
      }
      return GetNearbyPlayersResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load players: $e');
    }
  }
}
