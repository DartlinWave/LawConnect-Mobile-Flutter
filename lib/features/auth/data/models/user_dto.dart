import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';

class UserDto {
  final String id;
  final String username;
  final String password;
  final int roleId;
  final String token;

  const UserDto({
    required this.id,
    required this.username,
    required this.password,
    required this.roleId,
    required this.token,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'],
      password: json['password'] ?? '',
      roleId: json['roleId'] ?? 0,
      token: json['token'] ?? '',
    );
  }

  User toDomain() {
    return User(
      id: id,
      username: username,
      password: password,
      roleId: roleId,
      token: token,
    );
  }
}
