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