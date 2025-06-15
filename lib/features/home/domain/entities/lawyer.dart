class Lawyer {
  final String name;
  final int rating;
  final String specialty;
  final String description;
  final String image;
  final List<Map<String, String>> customers;

  Lawyer({
    required this.name,
    required this.rating,
    required this.specialty,
    required this.description,
    required this.image,
    this.customers = const [],
  });
}