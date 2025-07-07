import 'package:lawconnect_mobile_flutter/features/profiles/data/models/contact_info_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/models/person_name_dto.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';

class ClientDto {
  final String id;
  final String userId;
  final PersonNameDto fullName;
  final String dni;
  final ContactInfoDto contactInfo;
  final String image;

  const ClientDto({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dni,
    required this.contactInfo,
    required this.image,
  });

  factory ClientDto.fromJson(Map<String, dynamic> json) {
    return ClientDto(
      id: json['id'],
      userId: json['userId'],
      fullName: PersonNameDto.fromJson(json['fullName']),
      dni: json['dni'],
      contactInfo: ContactInfoDto.fromJson(json['contactInfo']),
      image: json['image'],
    );
  }

  Client toDomain() {
    return Client(
      id: id,
      userId: userId,
      fullName: fullName.toDomain(),
      dni: dni,
      contactInfo: contactInfo.toDomain(),
      image: image,
    );
  }
}
