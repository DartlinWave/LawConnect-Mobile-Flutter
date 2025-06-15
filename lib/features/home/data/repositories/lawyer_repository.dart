import 'package:flutter/widgets.dart';
import 'package:lawconnect_mobile_flutter/features/home/data/datasources/lawyer_dao.dart';
import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';

//datos, lógica y presentación

//el repositorio es la capa de negocio (lógica/business)
class LawyerRepository {

  //Esta es la capa de datos
  final LawyerDao _lawyerDao = LawyerDao();

  Future<List<Lawyer>> fetchAll() async {
    // This method will fetch all lawyers from the data source.
    final dtos = await _lawyerDao.fetchAll();
    debugPrint('LawyerRepository: fetchAll called, fetched ${dtos.length} lawyers');

    return dtos.map((dto) => dto.toDomain()).toList();
  }
}