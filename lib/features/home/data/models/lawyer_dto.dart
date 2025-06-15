import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';

class LawyerDto {


  final String name;
  final int rating;
  final String specialty;
  final String description;
  final String image;
  
  
  LawyerDto({

    required this.name,
    required this.rating,
    required this.specialty,
    required this.description,
    required this.image,
  });


factory LawyerDto.fromMap(Map<String, dynamic> map) {
    return LawyerDto(
      
      name: map['name'] as String, //nombre
      rating: map['rating'] as int, //rankin
      specialty: map['specialty'] as String, //spec
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }

//convert LawyerDto to Lawyer entity
Lawyer toDomain() {
    return Lawyer(      
      name: name, //nombre
      rating: rating, //rankin
      specialty: specialty,
      description: description,
      image: image,
    );
  }

}