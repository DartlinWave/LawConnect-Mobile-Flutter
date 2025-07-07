import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class CaseDto {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final CaseStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;

  const CaseDto({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CaseDto.fromJson(Map<String, dynamic> json) {
    return CaseDto(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: CaseStatus.values.byName(json['status'] as String),
      image: json['image'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Case toDomain() {
    return Case(
      id: id,
      clientId: clientId,
      title: title,
      description: description,
      status: status,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}