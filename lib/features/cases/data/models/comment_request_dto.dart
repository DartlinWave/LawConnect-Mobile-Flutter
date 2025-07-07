class CommentRequestDto {
  final String caseId;
  final String authorId;
  final String type;
  final String comment;
  final String createdAt;

  const CommentRequestDto({
    required this.caseId,
    required this.authorId,
    required this.type,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'caseId': caseId,
      'authorId': authorId,
      'type': type,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}