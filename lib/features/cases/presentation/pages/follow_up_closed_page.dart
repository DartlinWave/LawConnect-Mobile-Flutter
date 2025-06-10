import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/actions_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/selected_lawyer_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/summary_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/timeline_view.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class FollowUpClosedPage extends StatefulWidget {
  const FollowUpClosedPage({
    super.key,
    required this.caseEntity,
    required this.client,
    required this.lawyer,
  });

  final Case caseEntity;
  final Client client;
  final Lawyer lawyer;

  @override
  State<FollowUpClosedPage> createState() => _FollowUpClosedPageState();
}

class _FollowUpClosedPageState extends State<FollowUpClosedPage> {
  late final Case caseEntity;
  late final Client client;
  late final Lawyer lawyer;

  // These are just placeholders for the actual path

  void _navigateToFullCase() {
    Navigator.pushNamed(context, '/path-to-insert', arguments: caseEntity);
  }

  void _navigateToFullProfileLawyer() {
    Navigator.pushNamed(context, '/path-to-insert', arguments: lawyer);
  }

  void _navigateToContactLawyer() {
    Navigator.pushNamed(context, '/path-to-insert', arguments: lawyer);
  }

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

  final List<Lawyer> _lawyer = [
    Lawyer(
      id: 22,
      userId: 22,
      name: 'Daniel',
      lastName: 'Gonzalez',
      dni: '87654322',
      phone: '987654322',
      description:
          'Abogado especializado en derecho laboral, con vasta experiencia en la defensa de trabajadores y resolución de conflictos laborales.',
      specialty: 'LABOR_LAW',
      image: 'https://randomuser.me/api/portraits/men/32.jpg',
      rating: 4.4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    caseEntity = widget.caseEntity;
    client = _client.firstWhere((c) => c.id == caseEntity.clientId);
    lawyer = _lawyer.firstWhere((l) => l.id == caseEntity.lawyerId);
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

              SizedBox(height: 6),

              SummaryView(
                caseEntity: caseEntity,
                lawyer: lawyer,
                onShowFullCase: _navigateToFullCase,
              ),

              SelectedLawyerView(
                caseEntity: caseEntity,
                lawyer: lawyer,
                onFullProfile: _navigateToFullProfileLawyer,
                onContact: _navigateToContactLawyer,
              ),

              TimelineView(caseEntity: caseEntity),

              ActionsView(caseEntity: caseEntity),

              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],


          ),


        ),
      ),
    );
  }
}
