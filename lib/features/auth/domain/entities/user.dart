class User {
  final String id;
  final String username;
  final String password;
  final int roleId;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.roleId,
    required this.token,
  });
}
