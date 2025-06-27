import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';

class CommentDto {
  final int commentId;
  final String caseId;
  final String authorId;
  final CommentType type;
  final String comment;
  final DateTime createdAt;

  const CommentDto({
    required this.commentId,
    required this.caseId,
    required this.authorId,
    required this.type,
    required this.comment,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      commentId: json['commentId'] as int,
      caseId: json['caseId'] as String,
      authorId: json['authorId'] as String,
      type: CommentType.values.byName(json['type'] as String),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Comment toDomain() {
    return Comment(
      commentId: commentId,
      caseId: caseId,
      authorId: authorId,
      type: type,
      comment: comment,
      createdAt: createdAt,
    );
  }
}
