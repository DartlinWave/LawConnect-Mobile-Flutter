class Case {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final CaseStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;
  final int? applicationsCount; // Campo opcional para el conteo de aplicaciones

  Case({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.applicationsCount,
  });
}

enum CaseStatus { OPEN, EVALUATION, ACCEPTED, CLOSED, CANCELED }
