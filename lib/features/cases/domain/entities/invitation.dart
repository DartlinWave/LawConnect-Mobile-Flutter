class Invitation {
  final int id;
  final String caseId;
  final String lawyerId;
  final InvitationStatus status;

  Invitation({
    required this.id,
    required this.caseId,
    required this.lawyerId,
    required this.status,
  });
}

enum InvitationStatus {
  PENDING,
  ACCEPTED,
  REJECTED,
}
