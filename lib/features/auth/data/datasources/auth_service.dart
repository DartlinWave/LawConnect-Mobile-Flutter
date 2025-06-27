// only made to get a user and its cases

import 'dart:convert';
import 'dart:io';

import 'package:lawconnect_mobile_flutter/features/auth/data/models/user_dto.dart';
import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class AuthService {

  final String baseUrl = 'http://localhost:3000';
  // final String baseUrl = 'http://10.0.2.2:3000';

  // this will change to POST later
  Future<User> login(String username, String password) async {
    final Uri uri = Uri.parse('$baseUrl/users').replace(
      queryParameters: {
        //until we have the login endpoint (TODO: connect with backend)
        'username': username,
        'password': password,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List users = jsonDecode(response.body) as List;

      if (users.isEmpty) {
        throw Exception('User not found');
      }

      final userDto = UserDto.fromJson(users.first as Map<String, dynamic>);
      return userDto.toDomain();
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
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
}
