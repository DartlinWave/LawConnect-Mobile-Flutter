import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/profiles/data/models/client_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/models/lawyer_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:http/http.dart' as http;
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class ProfileService {
  final String baseUrl = 'http://localhost:8080/api/v1';
  // final String baseUrl = 'http://10.0.2.2:3000';

  // to get client profile by userId
  Future<Client> fetchClientProfileByUserId(String userId, String token) async {
    final uri = Uri.parse('$baseUrl/clients/$userId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      final clientDto = ClientDto.fromJson(jsonDecode(response.body));
      return clientDto.toDomain();
    } else {
      throw Exception(
        'Failed to fetch client profile by userId: ${response.statusCode}',
      );
    }
  }

  // to get all lawyers
  Future<List<Lawyer>> fetchAllLawyers() async {
    final uri = Uri.parse('$baseUrl/lawyer_profiles');

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List lawyers = jsonDecode(response.body);

      if (lawyers.isEmpty) {
        throw Exception('No lawyers found');
      }

      return lawyers
          .map((lawyer) => LawyerDto.fromJson(lawyer).toDomain())
          .toList();
    } else {
      throw Exception('Failed to fetch lawyers: ${response.statusCode}');
    }
  }

  // to get lawyer by id
  Future<Lawyer> fetchLawyerById(String id, String token) async {
    final uri = Uri.parse('$baseUrl/lawyers/$id');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('DEBUG: fetchLawyerById status: ${response.statusCode}');
    print('DEBUG: fetchLawyerById body: ${response.body}');

    if (response.statusCode == HttpStatus.ok) {
      final lawyerDto = LawyerDto.fromJson(jsonDecode(response.body));
      return lawyerDto.toDomain();
    } else {
      throw Exception(
        'Failed to fetch lawyer: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // to get client by userId
  Future<Client> fetchClientByUserId(String userId, String token) async {
    final uri = Uri.parse('$baseUrl/clients/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final clientDto = ClientDto.fromJson(jsonDecode(response.body));
      return clientDto.toDomain();
    } else {
      throw Exception('Failed to fetch client: ${response.statusCode}');
    }
  }

  // to get lawyer by caseId
  Future<Lawyer> fetchLawyerByCaseId(String caseId) async {
    final uri = Uri.parse(
      '$baseUrl/lawyer_profiles',
    ).replace(queryParameters: {'caseId': caseId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final lawyer = jsonDecode(response.body);

      if (lawyer.isEmpty) {
        throw Exception('No lawyer found for case ID: $caseId');
      }

      return LawyerDto.fromJson(
        lawyer.first as Map<String, dynamic>,
      ).toDomain();
    } else {
      throw Exception(
        'Failed to fetch lawyer: ${response.statusCode} for case $caseId',
      );
    }
  }

  Future<Map<String, dynamic>> createClientProfile({
    required String userId,
    required String firstname,
    required String lastname,
    required String dni,
    required String phoneNumber,
    required String address,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/clients');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'firstname': firstname,
        'lastname': lastname,
        'dni': dni,
        'contactInfo': {'phoneNumber': phoneNumber, 'address': address},
      }),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to create client profile: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Client> fetchClientProfileByDni(String dni, String token) async {
    final uri = Uri.parse('$baseUrl/clients/$dni');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      final clientDto = ClientDto.fromJson(jsonDecode(response.body));
      return clientDto.toDomain();
    } else {
      throw Exception(
        'Failed to fetch client profile by DNI: ${response.statusCode}',
      );
    }
  }
}
