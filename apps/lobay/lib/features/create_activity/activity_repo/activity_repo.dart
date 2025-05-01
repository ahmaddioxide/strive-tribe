import 'dart:developer';

import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/create_activity_body.dart';

class ActivityRepo {
  final apiClient = ApiClient();

  Future<dynamic> createActivity(CreateActivityBody createActivityBody) async {
    try {
      final response = await apiClient.post(
        EndPoints.createActivity,
        retryCallback: () {},
        data: createActivityBody.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Handle success
        return response.data;
      } else {
        // Handle error
        log('Error: ${response.statusCode}');
        log('Error message: ${response.data}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
