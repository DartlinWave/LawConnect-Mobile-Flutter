import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/contact_info.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/person_name.dart';

class Lawyer {
  final String id;
  final String userId;
  final PersonName fullName;
  final String dni;
  final ContactInfo contactInfo;
  final String description;
  final List<Specialty> specialties;
  final String image;
  final double rating;

  Lawyer({
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
}

enum Specialty {
  CRIMINAL_LAW,
  CIVIL_LITIGATION,
  FAMILY_LAW,
  CORPORATE_LAW,
  TAX_LAW,
  INTELLECTUAL_PROPERTY,
  IMMIGRATION_LAW,
  REAL_ESTATE_LAW,
  EMPLOYMENT_LAW,
  ENVIRONMENTAL_LAW,
  BANKRUPTCY_LAW,
  PERSONAL_INJURY,
  MEDICAL_MALPRACTICE,
  ESTATE_PLANNING,
  ELDER_LAW,
  CONSTITUTIONAL_LAW,
  INTERNATIONAL_LAW,
  SECURITIES_LAW,
  CONSUMER_PROTECTION,
  CONTRACT_LAW,
  EDUCATION_LAW,
  ENTERTAINMENT_LAW,
  SPORTS_LAW,
  MILITARY_LAW,
  ADMINISTRATIVE_LAW,
  HEALTHCARE_LAW,
  INSURANCE_LAW,
  CONSTRUCTION_LAW,
  MARITIME_LAW,
  HUMAN_RIGHTS_LAW,
  SOCIAL_SECURITY_LAW,
  PRODUCT_LIABILITY,
  MUNICIPAL_LAW,
  AGRICULTURAL_LAW,
  CYBER_LAW,
  DATA_PRIVACY_LAW,
  AVIATION_LAW,
  ANIMAL_LAW,
}
