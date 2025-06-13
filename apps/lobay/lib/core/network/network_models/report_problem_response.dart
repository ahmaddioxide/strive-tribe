class ReportProblemResponse {
  final bool success;
  final String message;
  final Report report;

  ReportProblemResponse({
    required this.success,
    required this.message,
    required this.report,
  });

  factory ReportProblemResponse.fromJson(Map<String, dynamic> json) {
    return ReportProblemResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      report: Report.fromJson(json['report'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'report': report.toJson(),
    };
  }
}

class Report {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
