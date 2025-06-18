class CaseRequestDto {
  final String status;
  final String updatedAt;

  const CaseRequestDto({
    required this.status,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'updatedAt': updatedAt,
    };
  }
}