import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:http/http.dart' as http;

class CaseService {
  Future<List<Case>> fetchCasesByClient(String clientId) async {
    final uri = Uri.parse('http://10.0.2.2:3000/cases')
    .replace(queryParameters: {'clientId': clientId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List cases = jsonDecode(response.body);
      
      if (cases.isEmpty) {
        throw Exception('There are no cases for this client');
      }

      return cases.map((cases) => CaseDto.fromJson(cases).toDomain()).toList();
    } else {
      throw Exception('Failed to fetch cases: ${response.statusCode} for client $clientId');
    }
  }

  Future<CaseDto> updateCaseStatus(String caseId, String newStatus) async {
    final uri = Uri.parse('http://10.0.2.2:3000/cases/$caseId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(CaseRequestDto(status: newStatus, updatedAt: DateTime.now().toIso8601String()).toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      return CaseDto.fromJson(caseData);
    } else {
      throw Exception('Failed to update case status: ${response.statusCode} for case $caseId');
    }
  }
}