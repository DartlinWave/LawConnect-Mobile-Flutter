import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/contact_info.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/person_name.dart';

class Client {
  final String id;
  final String userId;
  final PersonName fullName;
  final String dni;
  final ContactInfo contactInfo;
  final String image;

  Client({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dni,
    required this.contactInfo,
    required this.image,
  });
}