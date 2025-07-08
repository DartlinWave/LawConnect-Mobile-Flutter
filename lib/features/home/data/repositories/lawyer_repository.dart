import 'package:flutter/widgets.dart';
import 'package:lawconnect_mobile_flutter/features/home/data/datasources/lawyer_dao.dart';
import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/datasources/profile_service.dart';

//datos, lógica y presentación

//el repositorio es la capa de negocio (lógica/business)
class LawyerRepository {
  //Esta es la capa de datos
  final LawyerDao _lawyerDao = LawyerDao();
  final ProfileService _profileService = ProfileService();

  Future<List<Lawyer>> fetchAll() async {
    // This method will fetch all lawyers from the data source.
    final dtos = await _lawyerDao.fetchAll();
    debugPrint(
      'LawyerRepository: fetchAll called, fetched ${dtos.length} lawyers',
    );

    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<List<Lawyer>> fetchAllFromAPI(String token) async {
    try {
      // Use ProfileService to get lawyers from API
      final profileLawyers = await _profileService.fetchAllLawyersFromUsers(
        token,
      );

      // Convert from profile Lawyer entity to home Lawyer entity
      return profileLawyers
          .map(
            (profileLawyer) => Lawyer(
              name:
                  '${profileLawyer.fullName.firstname} ${profileLawyer.fullName.lastname}',
              specialty: profileLawyer.specialties.isNotEmpty
                  ? _formatSpecialty(profileLawyer.specialties.first)
                  : 'General Practice',
              rating: profileLawyer.rating.round(), // Convert double to int
              image: profileLawyer.image,
              description: profileLawyer.description,
              customers: const [], // Empty for now
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('LawyerRepository: Error fetching lawyers from API: $e');
      throw Exception('Failed to fetch lawyers from API: $e');
    }
  }

  String _formatSpecialty(String specialty) {
    final formatSpecialty = specialty.replaceAll("_LAW", "").toLowerCase();
    return formatSpecialty[0].toUpperCase() + formatSpecialty.substring(1);
  }
}
