import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:http/http.dart' as http;

class CommentService {
  
  final String baseUrl = 'http://localhost:3000';
  // final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Comment>> fetchCommentsByCaseId(String caseId) async {
    final uri = Uri.parse('$baseUrl/comments')
    .replace(queryParameters: {'caseId': caseId});
    
    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List comments = jsonDecode(response.body);
      
      if (comments.isEmpty) {
        throw Exception('There are no comments for this case');
      }

      return comments.map((comment) => CommentDto.fromJson(comment).toDomain()).toList();
    } else {
      throw Exception('Failed to fetch comments: ${response.statusCode} for case $caseId');
    }
  }

  Future<Comment?> fetchFinalReviewCommentByCaseId(String caseId) async {
    final uri = Uri.parse('$baseUrl/comments')
        .replace(queryParameters: {'caseId': caseId, 'type': 'FINAL_REVIEW'});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final List comments = jsonDecode(response.body);

      if (comments.isEmpty) {
        return null;
      }

      return CommentDto.fromJson(comments.first).toDomain();

    } else {
      throw Exception('Failed to fetch final review comment: ${response.statusCode} for case $caseId');
    }
  }

  Future<Comment> createComment(CommentRequestDto request) async {
    final uri = Uri.parse('$baseUrl/comments');

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
