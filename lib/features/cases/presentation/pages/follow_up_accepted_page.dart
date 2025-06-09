import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/summary_view.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class FollowUpAcceptedPage extends StatefulWidget {
  const FollowUpAcceptedPage({super.key, required this.caseEntity, required this.client, required this.lawyer});

  final Case caseEntity;
  final Client client;
  final Lawyer lawyer;

  @override
  State<FollowUpAcceptedPage> createState() => _FollowUpAcceptedPageState();
}

class _FollowUpAcceptedPageState extends State<FollowUpAcceptedPage> {
  late final Case caseEntity;
  late final Client client;
  late final Lawyer lawyer;

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

  final List<Lawyer> _lawyers = [
    Lawyer(
      id: 12,
      userId: 12,
      name: 'John',
      lastName: 'Rivas',
      dni: '87654321',
      phone: '987654321',
      description:
          'Abogado especializado en derecho de familia, con amplia experiencia en casos de custodia, divorcios y acuerdos de visitas.',
      specialty: 'FAMILY_LAW',
      image: 'https://randomuser.me/api/portraits/men/31.jpg',
      rating: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    caseEntity = widget.caseEntity;
    client = _client.firstWhere((c) => c.id == caseEntity.clientId);
    lawyer = _lawyers.firstWhere((l) => l.id == caseEntity.lawyerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicAppBar(title: client.username),

              SizedBox(height: 16),

              SummaryView(caseEntity: caseEntity)
            ],
          ),
        ),
      ),
    );
  }
}
