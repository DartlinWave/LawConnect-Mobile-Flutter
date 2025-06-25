import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/summary_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key, required this.chosenCase});

  final Case chosenCase;

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
void _navigateToFullCase() {
  Navigator.pushNamed(context, '/path-to-insert', arguments: widget.chosenCase);
}

late final String clientId;

  @override
  void initState() {
    super.initState();
      context.read<CaseBloc>().add(GetCaseDetailsEvent(caseId: widget.chosenCase.id));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final clientUsername = authState is SuccessAuthState
        ? authState.user.username
        : "Unknown User";

    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicAppBar(title: clientUsername),

              SizedBox(height: 16),
              
              SummaryView(caseEntity: widget.chosenCase, onShowFullCase: _navigateToFullCase)
            ],
          ),
        ),
      ),
    );
  }
}
