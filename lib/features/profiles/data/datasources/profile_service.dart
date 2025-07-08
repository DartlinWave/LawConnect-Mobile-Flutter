import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:lawconnect_mobile_flutter/features/profiles/data/models/client_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/models/lawyer_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class ProfileService {
  final String baseUrl = 'https://lawconnect-backend-y48f.onrender.com/api/v1';
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

  // New method to get all lawyers by fetching users with ROLE_LAWYER and then their profiles
  Future<List<Lawyer>> fetchAllLawyersFromUsers(String token) async {
    try {
      // Step 1: Get all users
      final authService = AuthService();
      final allUsers = await authService.fetchAllUsers();

      // Step 2: Filter users with ROLE_LAWYER (roleId = 1)
      final lawyerUsers = allUsers.where((user) => user.roleId == 1).toList();

      // Step 3: Fetch lawyer profiles for each lawyer user
      final List<Lawyer> lawyers = [];

      for (final user in lawyerUsers) {
        try {
          final lawyer = await fetchLawyerById(user.id, token);
          // Add a placeholder image since we don't get images from the API
          final lawyerWithImage = Lawyer(
            id: lawyer.id,
            userId: lawyer.userId,
            fullName: lawyer.fullName,
            dni: lawyer.dni,
            contactInfo: lawyer.contactInfo,
            description: lawyer.description,
            specialties: lawyer.specialties,
            image: 'https://via.placeholder.com/150', // Template image
            rating: lawyer.rating,
          );
          lawyers.add(lawyerWithImage);
        } catch (e) {
          print('Failed to fetch lawyer profile for user ${user.id}: $e');
          // Continue with other lawyers even if one fails
        }
      }

      return lawyers;
    } catch (e) {
      throw Exception('Failed to fetch all lawyers: $e');
    }
  }

  // to get client profile by dni
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

  /// Creates a new client profile
  Future<Map<String, dynamic>> createClientProfile({
    required String userId,
    required String firstname,
    required String lastname,
    required String dni,
    String? address,
    String? phoneNumber,
    String? email,
  }) async {
    final url = Uri.parse('$baseUrl/clients');
    final requestBody = {
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'dni': dni,
      if (address != null) 'address': address,
      if (phoneNumber != null) 'phone': phoneNumber,
      if (email != null) 'email': email,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      debugPrint('ProfileService.createClientProfile: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to create client profile: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('ProfileService.createClientProfile error: $e');
      throw Exception('Error creating client profile: $e');
    }
  }
}
