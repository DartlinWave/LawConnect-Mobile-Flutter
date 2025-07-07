import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_update_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/comment_service.dart';
import 'package:http/http.dart' as http;

class CaseService {
  final String baseUrl = 'http://localhost:8080/api/v1';

  Future<List<Case>> fetchCasesByClient(String clientId, String token) async {
    final uri = Uri.parse('$baseUrl/cases/clients/$clientId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      final decoded = jsonDecode(response.body);
      print('DEBUG fetchCasesByClient response:');
      print(decoded);
      if (decoded is List && decoded.isEmpty) {
        throw Exception('There are no cases for this client');
      }

      final cases = (decoded as List)
          .map((caseEntity) => CaseDto.fromJson(caseEntity))
          .map((dto) => dto.toDomain())
          .toList();

      // Para casos en EVALUATION, obtener el conteo de aplicaciones
      for (int i = 0; i < cases.length; i++) {
        if (cases[i].status.name == 'EVALUATION') {
          try {
            final applicationsCount = await ApplicationService()
                .fetchApplicationsCountByCaseId(cases[i].id, token);
            // Crear un nuevo caso con el conteo actualizado
            cases[i] = Case(
              id: cases[i].id,
              clientId: cases[i].clientId,
              title: cases[i].title,
              description: cases[i].description,
              status: cases[i].status,
              image: cases[i].image,
              createdAt: cases[i].createdAt,
              updatedAt: cases[i].updatedAt,
              applicationsCount: applicationsCount,
            );
            print('Case ${cases[i].id} has $applicationsCount applications');
          } catch (e) {
            print(
              'Error fetching applications count for case ${cases[i].id}: $e',
            );
            // Si falla, asignar al menos 1 para casos en EVALUATION
            cases[i] = Case(
              id: cases[i].id,
              clientId: cases[i].clientId,
              title: cases[i].title,
              description: cases[i].description,
              status: cases[i].status,
              image: cases[i].image,
              createdAt: cases[i].createdAt,
              updatedAt: cases[i].updatedAt,
              applicationsCount: 1, // Mínimo 1 para casos en EVALUATION
            );
          }
        }
      }

      return cases;
    } else {
      throw Exception(
        'Failed to fetch cases: ${response.statusCode} for client $clientId',
      );
    }
  }

  Future<Case> createCase({
    required String clientId,
    required String title,
    required String description,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/cases');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'clientId': clientId,
        'title': title,
        'description': description,
      }),
    );
    if (response.statusCode == HttpStatus.ok || response.statusCode == 201) {
      final caseData = jsonDecode(response.body);
      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception('Failed to create case: ${response.statusCode}');
    }
  }

  Future<Case> fetchCaseById(String caseId, String token) async {
    final uri = Uri.parse('$baseUrl/cases/$caseId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      if (caseData.isEmpty) {
        throw Exception('Case not found for ID: $caseId');
      }
      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception(
        'Failed to fetch case: ${response.statusCode} for case $caseId',
      );
    }
  }

  Future<Case> updateCaseStatus(String caseId, String newStatus) async {
    final uri = Uri.parse('$baseUrl/cases/$caseId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        CaseUpdateRequestDto(
          status: newStatus,
          updatedAt: DateTime.now().toIso8601String(),
        ).toJson(),
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception(
        'Failed to update case status: ${response.statusCode} for case $caseId',
      );
    }
  }

  Future<Case> finishCaseStatus(String caseId, String newStatus) async {
    final uri = Uri.parse('$baseUrl/cases/$caseId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        CaseRequestDto(
          status: newStatus,
          updatedAt: DateTime.now().toIso8601String(),
        ).toJson(),
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final caseData = jsonDecode(response.body);
      return CaseDto.fromJson(caseData).toDomain();
    } else {
      throw Exception(
        'Failed to update case status: ${response.statusCode} for case $caseId',
      );
    }
  }

  Future<List<Case>> fetchCasesByStatus({
    required String status,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/cases/status?status=$status');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      final decoded = jsonDecode(response.body);
      if (decoded is List && decoded.isEmpty) {
        throw Exception('There are no cases with status $status');
      }
      return (decoded as List)
          .map((caseEntity) => CaseDto.fromJson(caseEntity))
          .map((dto) => dto.toDomain())
          .toList();
    } else {
      throw Exception(
        'Failed to fetch cases by status: \\${response.statusCode} for status $status',
      );
    }
  }
}
