class Case {
  final String id;
  final String clientId;
  final String lawyerId;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Case({
    required this.id,
    required this.clientId,
    required this.lawyerId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

}