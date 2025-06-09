import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_accepted_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_closed_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_in_evaluation_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_open_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_card_view.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases, required this.client, required this.allLawyers});

  final List<Case> cases;
  final Client client;
  final List<Lawyer> allLawyers;

void _navigateToCaseFollowUp(BuildContext context, Case caseEntity) {
    Widget page;

    final Lawyer? _selectedLawyer = allLawyers.firstWhere(
      (l) => l.id == caseEntity.lawyerId,
      orElse: () => Lawyer(id: 0, userId: 0, name: '', lastName: '', dni: '', phone: '', description: '', specialty: '', image: '', rating: 0.0),
    );

    switch (caseEntity.status) {
      case "OPEN_STATUS":
        page = FollowUpOpenPage(caseEntity: caseEntity, client: client);
        break;
      case "IN_EVALUATION_STATUS":
        page = FollowUpInEvaluationPage(caseEntity: caseEntity, client: client);
        break;
      case "ACCEPTED_STATUS":
        page = FollowUpAcceptedPage(caseEntity: caseEntity, client: client, lawyer: _selectedLawyer!);
        break;
      case "CLOSED_STATUS":
        page = FollowUpClosedPage(caseEntity: caseEntity, client: client, lawyer: _selectedLawyer!);
        break;
      default:
        throw Exception("Unknown case status: ${caseEntity.status}");
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: cases.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        ),
       itemBuilder: (context, index) {
        final caseItem = cases[index];
        return CaseCardView(
          caseEntity: caseItem, 
          onFollowUpToCase: () => _navigateToCaseFollowUp(context, caseItem),
        );
       }
      );
  }
}