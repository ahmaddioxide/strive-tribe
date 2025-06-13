// {
//     "success": true,
//     "terms": {
//         "version": "1.0",
//         "content": "## 📄 Strive Tribe – Terms of Service\n\n**Effective Date:** June 11, 2025  \n**Last Updated:** June 11, 2025\n\nWelcome to **Strive Tribe** (“App”, “we”, “our”, “us”). These Terms of Service (“Terms”) govern your use of the Strive Tribe mobile application, available in the United States.\n\nBy using the App, you agree to these Terms. If you do not agree, please do not use the App.\n\n---\n\n### 1. Eligibility\nYou must be at least **13 years old** to use Strive Tribe. If you are under 18, you must have permission from a parent or guardian.\n\n---\n\n### 2. User Responsibilities\nBy using Strive Tribe, you agree to:\n- Provide accurate information during registration\n- Not impersonate another person or use a fake identity\n- Not use the platform for harassment, threats, or inappropriate behavior\n- Not engage in any activity that violates local, state, or federal law\n\n---\n\n### 3. Creating and Participating in Activities\nStrive Tribe allows users to create and join **sport and recreational activities**. You agree:\n- To behave respectfully and safely during in-person meetups\n- That we are **not responsible for user conduct** during or after events\n- To meet in **safe, public locations** whenever possible\n\nYou are solely responsible for your participation and any resulting interactions.\n\n---\n\n### 4. User Interactions & Messaging\nStrive Tribe allows **direct messaging** between users. By using this feature, you agree not to:\n- Send spam or unsolicited messages\n- Use abusive, discriminatory, or offensive language\n- Share or solicit inappropriate content\n\nWe reserve the right to monitor or remove content that violates our policies.\n\n---\n\n### 5. Safety & Reporting\nUser safety is our priority. If you experience unsafe behavior or violations, please use the in-app **report** feature or contact support at: [support@strivetribe.com].\n\nWe reserve the right to **suspend or ban** any user for violating these Terms.\n\n---\n\n### 6. Account Termination\nYou may delete your account at any time. We may suspend or terminate your access if you violate these Terms or engage in harmful conduct.\n\n---\n\n### 7. Privacy\nWe collect limited personal information as described in our Privacy Policy. We will not share or sell your personal data to third parties without your consent, unless required by law.\n\n---\n\n### 8. Limitation of Liability\nStrive Tribe is provided \"as is.\" We do not guarantee:\n- Safety or accuracy of user-created events\n- Compatibility with all devices or operating systems\n- Continuous or error-free operation\n\nWe are not liable for damages arising from user interactions or third-party behavior.\n\n---\n\n### 9. Modifications to Terms\nWe may update these Terms from time to time. Continued use after changes means you agree to the revised Terms.\n\n---\n\n### 10. Contact\nIf you have questions about these Terms, please contact:\n📧 support@strivetribe.com\n",
//         "effectiveDate": "2025-06-11T00:00:00.000Z"
//     }
// }

class TermsAndPolicyResponse {
  final bool success;
  final Terms terms;

  TermsAndPolicyResponse({
    required this.success,
    required this.terms,
  });

  factory TermsAndPolicyResponse.fromJson(Map<String, dynamic> json) {
    return TermsAndPolicyResponse(
      success: json['success'] as bool,
      terms: Terms.fromJson(json['terms'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'terms': terms.toJson(),
    };
  }
}

class Terms {
  final String version;
  final String content;
  final DateTime effectiveDate;

  Terms({
    required this.version,
    required this.content,
    required this.effectiveDate,
  });

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      version: json['version'] as String,
      content: json['content'] as String,
      effectiveDate: DateTime.parse(json['effectiveDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'content': content,
      'effectiveDate': effectiveDate.toIso8601String(),
    };
  }
}
