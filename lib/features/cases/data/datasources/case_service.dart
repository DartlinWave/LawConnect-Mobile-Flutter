import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_update_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:http/http.dart' as http;

class CaseService {
  
  final String baseUrl = 'http://localhost:3000';
  // final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Case>> fetchCasesByClient(String clientId) async {
    final uri = Uri.parse('$baseUrl/cases')
    .replace(queryParameters: {'clientId': clientId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List cases = jsonDecode(response.body);
      
      if (cases.isEmpty) {
        throw Exception('There are no cases for this client');
      }

      return cases.map((caseEntity) => CaseDto.fromJson(caseEntity).toDomain()).toList();
    } else {
      throw Exception('Failed to fetch cases: ${response.statusCode} for client $clientId');
    }
  }

  Future<Case> fetchCaseById(String caseId) async {
    final uri = Uri.parse('$baseUrl/cases/$caseId');
    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      
      if (caseData.isEmpty) {
        throw Exception('Case not found for ID: $caseId');
      }

      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception('Failed to fetch case: ${response.statusCode} for case $caseId');
    }
  }

  Future<Case> updateCaseStatus(String caseId, String newStatus) async {
    final uri = Uri.parse('$baseUrl/cases/$caseId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CaseUpdateRequestDto(status: newStatus, updatedAt: DateTime.now().toIso8601String()).toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception('Failed to update case status: ${response.statusCode} for case $caseId');
    }
  }

  Future<Case> finishCaseStatus(String caseId, String newStatus, String comment) async {
    final uri = Uri.parse('$baseUrl/cases/$caseId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CaseRequestDto(status: newStatus, comment: comment, updatedAt: DateTime.now().toIso8601String()).toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception('Failed to update case status: ${response.statusCode} for case $caseId');
    }
  }
}