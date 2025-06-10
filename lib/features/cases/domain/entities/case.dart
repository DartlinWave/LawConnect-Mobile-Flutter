import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/applicant.dart';

class Case {
  final int id;
  final int clientId;
  final int lawyerId; // Nullable if the case is not assigned to a lawyer
  final String title;
  final String description;
  final String specialty;
  final String status;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Applicant> applicants;
  final String comment;

  Case({
    required this.id,
    required this.clientId,
    required this.lawyerId,
    required this.title,
    required this.description,
    required this.specialty,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.applicants,
    required this.comment,
  });

}
