import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/case_update_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/comment_service.dart';
import 'package:http/http.dart' as http;

class CaseService {
  final String baseUrl = 'https://lawconnect-backend-y48f.onrender.com/api/v1';

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

  Future<bool> closeCase(
    String caseId,
    String clientId, {
    String? token,
  }) async {
    // Make sure we're using the exact format expected by the API
    final uri = Uri.parse('$baseUrl/cases/$caseId/close?clientId=$clientId');
    print('Closing case with URI: $uri');
    print('Using clientId: $clientId');

    try {
      // Create headers map with required headers
      final headers = {'Content-Type': 'application/json'};

      // Add authorization token if provided
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('Headers: $headers');

      // Try with an empty body object, some APIs expect this even with query parameters
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode({}), // Empty JSON body as some backends expect this
      );

      print('Close case response status: ${response.statusCode}');
      print('Close case response body: "${response.body}"');

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == 200 ||
          response.statusCode == 204) {
        // Also accept 204 No Content
        // If response body is empty, just return true to indicate success
        if (response.body.isEmpty || response.body.trim() == '') {
          print('Empty response body, but successful status code');
          return true;
        }

        // If we have a body, try to decode it but don't fail if it doesn't work
        try {
          if (response.body.isNotEmpty) {
            final decodedBody = jsonDecode(response.body);
            print('Decoded response body: $decodedBody');
          }
          return true;
        } catch (e) {
          print(
            'Error parsing close case response: $e. Returning success anyway since status code is OK',
          );
          return true;
        }
      } else {
        // Log the error response
        print(
          'Failed to close case. Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to close case: ${response.statusCode} for case $caseId. Response: ${response.body}',
        );
      }
    } catch (e) {
      print('Exception in closeCase: $e');
      throw Exception('Failed to close case: $e');
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
