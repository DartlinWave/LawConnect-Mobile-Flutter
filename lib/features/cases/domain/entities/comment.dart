class Comment {
  final String commentId;
  final String caseId;
  final String authorId;
  final CommentType type;
  final String comment;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.caseId,
    required this.authorId,
    required this.type,
    required this.comment,
    required this.createdAt,
  });
}

enum CommentType {
  GENERAL,
  FINAL_REVIEW
}