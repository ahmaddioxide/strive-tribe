class ReportProblemBody {
  final String name;
  final String email;
  final String description;

  ReportProblemBody({
    required this.name,
    required this.email,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'description': description,
    };
  }
}
