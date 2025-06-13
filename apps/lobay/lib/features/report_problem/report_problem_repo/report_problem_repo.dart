import 'package:lobay/common_widgets/app_snackbars.dart';
import 'package:lobay/core/network/api_client.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/core/network/network_models/report_problem_body.dart';
import 'package:lobay/core/network/network_models/report_problem_response.dart';

class ReportProblemRepo {
  final ApiClient apiClient = ApiClient();

  Future<ReportProblemResponse> reportProblem(ReportProblemBody body) async {
    final response = await apiClient.post(
      EndPoints.reportProblem,
      retryCallback: () {},
      data: body.toJson(),
    );
    if (response.statusCode == 201) {
      return ReportProblemResponse.fromJson(response.data);
    } else {
      AppSnackbar.showErrorSnackBar(message: response.data['error']);
      throw Exception('Failed to report problem');
    }
  }
}
