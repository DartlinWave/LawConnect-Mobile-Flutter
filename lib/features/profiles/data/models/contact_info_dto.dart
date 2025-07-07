import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/contact_info.dart';

class ContactInfoDto {
  final String phoneNumber;
  final String address;

  const ContactInfoDto({
    required this.phoneNumber,
    required this.address,
  });

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) {
    return ContactInfoDto(
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

  ContactInfo toDomain() {
    return ContactInfo(
      phoneNumber: phoneNumber, 
      address: address);
  }
}