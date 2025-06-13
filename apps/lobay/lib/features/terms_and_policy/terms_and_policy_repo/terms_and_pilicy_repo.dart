import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/terms_and_policy_reponse.dart';

class TermsAndPolicyRepo {
  final ApiClient apiClient = ApiClient();

  Future<TermsAndPolicyResponse> getTermsAndPolicy() async {
    final response = await apiClient.get(
      EndPoints.termsAndPolicy,
      retryCallback: () {
        return true;
      },
    );
    if (response.statusCode == 200) {
      return TermsAndPolicyResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load terms and policy');
    }
  }
}
