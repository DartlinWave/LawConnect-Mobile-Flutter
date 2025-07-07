import 'package:lawconnect_mobile_flutter/features/profiles/data/models/contact_info_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/models/person_name_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class LawyerDto {
  final String id;
  final String userId;
  final PersonNameDto fullName;
  final String dni;
  final ContactInfoDto contactInfo;
  final String description;
  final List<String> specialties;
  final String image;
  final double rating;

  const LawyerDto({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dni,
    required this.contactInfo,
    required this.description,
    required this.specialties,
    required this.image,
    required this.rating,
  });

  factory LawyerDto.fromJson(Map<String, dynamic> json) {
    return LawyerDto(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] != null
          ? PersonNameDto.fromJson(json['fullName'])
          : PersonNameDto(firstname: '', lastname: ''),
      dni: json['dni'] ?? '',
      contactInfo: json['contactInfo'] != null
          ? ContactInfoDto.fromJson(json['contactInfo'])
          : ContactInfoDto(phoneNumber: '', address: ''),
      description: json['description'] ?? '',
      specialties: json['specialties'] != null
          ? List<String>.from(json['specialties'] as List)
          : <String>[],
      image: json['image'] ?? '',
      rating: (json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0),
    );
  }

  Lawyer toDomain() {
    return Lawyer(
      id: id,
      userId: userId,
      fullName: fullName.toDomain(),
      dni: dni,
      contactInfo: contactInfo.toDomain(),
      description: description,
      specialties: specialties,
      image: image,
      rating: rating,
    );
  }
}
