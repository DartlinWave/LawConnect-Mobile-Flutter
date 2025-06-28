import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_card_view.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases});

  final List<Case> cases;

  void _navigateToCaseFollowUp(BuildContext context, Case caseEntity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (ctx) => CaseDetailsBloc()..add(GetCaseDetailsEvent(caseId: caseEntity.id)),
          child: FollowUpPage(chosenCase: caseEntity),
        ),
      ),
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
      },
    );
  }
}
