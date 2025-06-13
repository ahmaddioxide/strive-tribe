import 'package:get/get.dart';
import 'package:lobay/core/network/network_models/terms_and_policy_reponse.dart';
import 'package:lobay/features/terms_and_policy/terms_and_policy_repo/terms_and_pilicy_repo.dart';

class TermsAndPolicyScreenController extends GetxController {
  final TermsAndPolicyRepo termsAndPolicyRepo = TermsAndPolicyRepo();

  RxBool isLoading = false.obs;
  Rx<TermsAndPolicyResponse?> termsAndPolicy =
      Rx<TermsAndPolicyResponse?>(null);
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndPolicy();
  }

  Future<void> fetchTermsAndPolicy() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await termsAndPolicyRepo.getTermsAndPolicy();
      termsAndPolicy.value = response;
    } catch (e) {
      errorMessage.value = 'An error occurred while loading terms and policy';
    } finally {
      isLoading.value = false;
    }
  }
}
