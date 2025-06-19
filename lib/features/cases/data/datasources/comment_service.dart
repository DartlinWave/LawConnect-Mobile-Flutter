import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:http/http.dart' as http;

class CommentService {
  Future<Comment> fetchCommentByCaseId(String caseId) async {
    final uri = Uri.parse('http://10.0.2.2:3000/comments')
    .replace(queryParameters: {'caseId': caseId});
    
    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final comment = jsonDecode(response.body);

      if (comment.isEmpty) {
        throw Exception('There is no comment for this case');
      }

      return CommentDto.fromJson(comment).toDomain();
    } else {
      throw Exception('Failed to fetch comment: ${response.statusCode} for case $caseId');
    }
  }

  Future<Comment> createComment(CommentRequestDto request) async {
    final uri = Uri.parse('http://10.0.2.2:3000/comments');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      final commentData = jsonDecode(response.body);
      return CommentDto.fromJson(commentData).toDomain();
    } else {
      throw Exception('Failed to create comment: ${response.statusCode}');
    }
  }
}