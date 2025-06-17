import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';

class Case {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;
  final List<Invitation> invitations;
  final List<Comment> comments;


  Case({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.invitations,
    required this.comments,
  });

}

enum CaseStatus {
  OPEN,
  EVALUATION,
  ACCEPTED,
  CLOSED,
  CANCELED
}