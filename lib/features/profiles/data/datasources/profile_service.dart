import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/profiles/data/models/client_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/models/lawyer_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:http/http.dart' as http;
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class ProfileService {

  // final String baseUrl = 'http://localhost:3000';
  final String baseUrl = 'http://10.0.2.2:3000';

  // to get client profile by userId
  Future<Client> fetchClientProfileByUserId(String userId) async {
    final uri = Uri.parse('$baseUrl/client_profiles')
    .replace(queryParameters: {'userId': userId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List clients = jsonDecode(response.body);

      if (clients.isEmpty) {
        throw Exception('Client profile not found');
      }

      final clientDto = ClientDto.fromJson(clients.first as Map<String, dynamic>);
      return clientDto.toDomain();
    } else {
      throw Exception('Failed to fetch client profile: ${response.statusCode}');
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

      return lawyers.map((lawyer) => LawyerDto.fromJson(lawyer).toDomain()).toList();
    } else {
      throw Exception('Failed to fetch lawyers: ${response.statusCode}');
    }
  }

  // to get lawyer by id
  Future<Lawyer> fetchLawyerById(String id) async {
    final uri = Uri.parse('$baseUrl/lawyer_profiles/$id');

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final lawyerDto = LawyerDto.fromJson(jsonDecode(response.body));
      return lawyerDto.toDomain();
    } else {
      throw Exception('Failed to fetch lawyer: ${response.statusCode}');
    }
  }

  // to get client by id
  Future<Client> fetchClientById(String id) async {
    final uri = Uri.parse('$baseUrl/client_profiles/$id');
    
    final response = await http.get(uri);
    
    if (response.statusCode == HttpStatus.ok) {
      final clientDto = ClientDto.fromJson(jsonDecode(response.body));
      return clientDto.toDomain();
    } else {
      throw Exception('Failed to fetch client: ${response.statusCode}');
    }
  }

  // to get lawyer by caseId
  Future<Lawyer> fetchLawyerByCaseId(String caseId) async {
    final uri = Uri.parse('$baseUrl/lawyer_profiles')
        .replace(queryParameters: {'caseId': caseId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final lawyer = jsonDecode(response.body);

      if (lawyer.isEmpty) {
        throw Exception('No lawyer found for case ID: $caseId');
      }

      return LawyerDto.fromJson(lawyer.first as Map<String, dynamic>).toDomain();
    } else {
      throw Exception('Failed to fetch lawyer: ${response.statusCode} for case $caseId');
    }
  }
}