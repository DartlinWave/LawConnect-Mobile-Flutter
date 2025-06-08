import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_accepted_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_closed_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_in_evaluation_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_open_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_card_view.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases });

  final List<Case> cases;

void _navigateToCaseFollowUp(BuildContext context, Case caseEntity) {
    Widget page;

    switch (caseEntity.status) {
      case "OPEN":
        page = FollowUpOpenPage(caseEntity: caseEntity);
        break;
      case "IN_EVALUATION":
        page = FollowUpInEvaluationPage(caseEntity: caseEntity);
        break;
      case "ACCEPTED":
        page = FollowUpAcceptedPage(caseEntity: caseEntity);
        break;
      case "CLOSED":
        page = FollowUpClosedPage(caseEntity: caseEntity);
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