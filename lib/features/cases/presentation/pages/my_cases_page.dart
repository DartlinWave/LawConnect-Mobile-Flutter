import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';

class MyCasesPage extends StatefulWidget {
  const MyCasesPage({super.key});

  @override
  State<MyCasesPage> createState() => _MyCasesPageState();
}

class _MyCasesPageState extends State<MyCasesPage> {
  @override
  Widget build(BuildContext context) {
    final List<Client> _client = [
    Client(
      id: 1,
      userId: 1,
      name: 'Jane',
      lastName: 'Doe',
      dni: '12345678',
      username: 'janedoe12',
      image:
          'https://economia3.com/wp-content/uploads/2019/12/Natalia-Juarranz-EQUIPO-HUMANO-450x450.jpg',
    ),
  ];


    final List<Case> _cases = [
  Case(
    id: 1,
    clientId: 1,
    lawyerId: 0,
    title: 'Divorce Case',
    description: 'Divorce case description',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'OPEN',
    specialty: 'Family',
    image: 'https://via.placeholder.com/150',
    applicants: [],
  ),
  Case(
    id: 2,
    clientId: 1,
    lawyerId: 0,
    title: 'Criminal Defense',
    description: 'Criminal case description',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'IN_EVALUATION',
    specialty: 'Criminal',
    image: 'https://via.placeholder.com/150',
    applicants: [],
  ),
  Case(
    id: 3,
    clientId: 1,
    lawyerId: 12,
    title: 'Land Dispute',
    description: 'Land dispute case',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'ACCEPTED',
    specialty: 'Property',
    image: 'https://via.placeholder.com/150',
    applicants: [],
  ),
  Case(
    id: 4,
    clientId: 1,
    lawyerId: 22,
    title: 'Labor Case',
    description: 'Labor rights concern',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'CLOSED',
    specialty: 'Labor',
    image: 'https://via.placeholder.com/150',
    applicants: [],
  ),
];
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
    );
  }
}