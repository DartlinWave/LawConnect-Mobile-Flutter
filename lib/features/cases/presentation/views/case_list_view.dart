import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_card_view.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases});

  final List<Case> cases;

  void _navigateToCaseFollowUp(BuildContext context, Case caseEntity) async {
    final authState = context.read<AuthBloc>().state;
    String token = "";
    if (authState is SuccessAuthState) {
      token = authState.user.token;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (ctx) =>
              CaseDetailsBloc()
                ..add(GetCaseDetailsEvent(caseId: caseEntity.id, token: token)),
          child: FollowUpPage(chosenCase: caseEntity, token: token),
        ),
      ),
    );

    context.read<CaseBloc>().add(
      GetCasesEvent(clientId: caseEntity.clientId, token: token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: cases.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
            0.85, // Un poco más altas que el default pero no tanto
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
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
