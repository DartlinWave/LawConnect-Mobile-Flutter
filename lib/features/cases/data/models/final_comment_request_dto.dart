class FinalCommentRequestDto {
  final String caseId;
  final String authorId;
  final String text;

  const FinalCommentRequestDto({
    required this.caseId,
    required this.authorId,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {'caseId': caseId, 'authorId': authorId, 'text': text};
  }
}
