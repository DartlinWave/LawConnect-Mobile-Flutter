import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/person_name.dart';

class PersonNameDto {
  final String firstname;
  final String lastname;

  const PersonNameDto({
    required this.firstname, 
    required this.lastname
    });

  factory PersonNameDto.fromJson(Map<String, dynamic> json) {
    return PersonNameDto(
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  PersonName toDomain() {
    return PersonName(
      firstname: firstname, 
      lastname: lastname
      );
  }
}
