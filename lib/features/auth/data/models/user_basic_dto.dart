import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';

class UserBasicDto {
  final String id;
  final String username;
  final String role;

  const UserBasicDto({
    required this.id,
    required this.username,
    required this.role,
  });

  factory UserBasicDto.fromJson(Map<String, dynamic> json) {
    return UserBasicDto(
      id: json['id'],
      username: json['username'],
      role: json['role'],
    );
  }

  User toDomain() {
    return User(
      id: id,
      username: username,
      password: '', // Not provided in this endpoint
      roleId: _getRoleId(role),
      token: '', // Not provided in this endpoint
    );
  }

  int _getRoleId(String role) {
    switch (role) {
      case 'ROLE_LAWYER':
        return 1;
      case 'ROLE_CLIENT':
        return 2;
      default:
        return 0;
    }
  }
}
