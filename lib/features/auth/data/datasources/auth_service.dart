// only made to get a user and its cases

import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/auth/data/models/user_dto.dart';
import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:8080/api/v1';

  Future<User> login(String username, String password) async {
    final Uri uri = Uri.parse('$baseUrl/authentication/sign-in');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userDto = UserDto.fromJson(data);
      return userDto.toDomain();
    } else {
      throw Exception(
        'Failed to login: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<User> fetchUserById(String userId) async {
    final uri = Uri.parse('$baseUrl/users/$userId');

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final userDto = UserDto.fromJson(jsonDecode(response.body));
      return userDto.toDomain();
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> signUp(String username, String password) async {
    final Uri uri = Uri.parse('$baseUrl/authentication/sign-up');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'role': 'ROLE_CLIENT',
      }),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to sign up: ${response.statusCode} ${response.body}',
      );
    }
  }
}
