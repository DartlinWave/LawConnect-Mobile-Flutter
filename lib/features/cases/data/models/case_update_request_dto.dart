class CaseUpdateRequestDto {
  final String status;
  final String updatedAt;

  const CaseUpdateRequestDto({
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