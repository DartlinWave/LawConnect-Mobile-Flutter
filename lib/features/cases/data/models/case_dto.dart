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
  final int? applicationsCount;

  const CaseDto({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.applicationsCount,
  });

  factory CaseDto.fromJson(Map<String, dynamic> json) {
    return CaseDto(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] != null
          ? CaseStatus.values.byName(json['status'])
          : CaseStatus.OPEN,
      image: json['image'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      applicationsCount: json['applicationsCount'] as int?,
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
      applicationsCount: applicationsCount,
    );
  }
}
