import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lawconnect_mobile_flutter/features/home/data/models/lawyer_dto.dart';

class LawyerDao {

  // This class will handle the data access for lawyers.
  // It will interact with the database or any other data source to fetch lawyer information.

  // Example method to get a list of lawyers
  Future<List<LawyerDto>> fetchAll() async {
    
    debugPrint('LawyerDao: fetchAll called');
    //Esto es cuando haya BD
    // final db = await AppDatabase().database;
    // final maps = await db.query('lawyers');

    //Por mientras se obtiene de un JSON estático//    
      final String response = await rootBundle.loadString('assets/lawyers.json');
      
      final List<dynamic> data = json.decode(response);
      //debugPrint('LawyerDao: fetchAll loaded ${data} lawyers from JSON');
      
      //debugPrint('LawyerDao: fetchAll completed with ${data.length} lawyers');
      return data.map((e) => LawyerDto.fromMap(e)).toList();    
  }

}