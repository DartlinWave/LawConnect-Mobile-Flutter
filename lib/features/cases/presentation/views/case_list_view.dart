import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_card_view.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases });

  final List<Case> cases;

void _navigateToCaseFollowUp(BuildContext context, Case caseEntity) {
    Widget page;

    switch (caseEntity.status) {
      case "OPEN":
        page = FollowUp
        break;
      case "IN_EVALUATION":
        page = Container(); // Replace with InEvaluationCaseFollowUpPage
        break;
      case "ACCEPTED":
        page = Container(); // Replace with AcceptedCaseFollowUpPage
        break;
      case "CLOSED":
        page = Container(); // Replace with ClosedCaseFollowUpPage
        break;
      default:
        throw Exception("Unknown case status: ${caseEntity.status}");
    }
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
          onFollowUpToCase: () {

          }
        );
       }
      );
  }
}