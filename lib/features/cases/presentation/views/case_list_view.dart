import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_card_view.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases, required this.client});

  final List<Case> cases;
  final Client client;

void _navigateToCaseFollowUp(BuildContext context, Case caseEntity) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FollowUpPage(
        chosenCase: caseEntity,
        client: client,
      )),
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
