class CaseRequestDto {
  final String caseId;
  final String status;
  final String updatedAt;

  const CaseRequestDto({
    required this.caseId,
    required this.status,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'caseId': caseId,
      'status': status,
      'updatedAt': updatedAt,
    };
  }
}