class Case {
  final int id;
  final int clientId;
  final String title;
  final String description;
  final String specialty;
  final String status;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Applicant> applicants;

  Case({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.specialty,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.applicants,
  });

}

class Applicant {
  final int id;
  final int lawyerId;
  final String name;
  final String specialty;
  final double rating;
  final String image;
  final String applicationStatus;
  final DateTime appliedAt;

  Applicant({
    required this.id,
    required this.lawyerId,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.image,
    required this.applicationStatus,
    required this.appliedAt,
  });
}