class Comment {
  final int commentId;
  final String caseId;
  final String authorId;
  final CommentStatus status;
  final String comment;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.caseId,
    required this.authorId,
    required this.status,
    required this.comment,
    required this.createdAt,
  });
}

enum CommentStatus {
  GENERAL,
  FINAL_REVIEW
}