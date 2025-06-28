import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/actions_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/selected_lawyer_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/summary_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/timeline_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key, required this.chosenCase});

  final Case chosenCase;

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  void _navigateToFullCase() {
    Navigator.pushNamed(
      context,
      '/path-to-insert',
      arguments: widget.chosenCase,
    );
  }

  void _navigateToFullLawyerProfile() {
    Navigator.pushNamed(
      context,
      '/path-to-insert',
      arguments: widget.chosenCase,
    );
  }

  void _navigateToContactLawyer() {
    Navigator.pushNamed(
      context,
      '/path-to-insert',
      arguments: widget.chosenCase,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CaseDetailsBloc>().add(
      GetCaseDetailsEvent(caseId: widget.chosenCase.id),
    );
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
          child: BlocBuilder<CaseDetailsBloc, CaseDetailsState>(
            builder: (context, state) {
              if (state is LoadedCaseDetailsState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackButton(
                        color: ColorPalette.blackColor,
                        onPressed: () => Navigator.pop(context),
                      ),

                      BasicAppBar(title: clientUsername),

                      SizedBox(height: 16),

                      SummaryView(
                        caseEntity: widget.chosenCase,
                        onShowFullCase: _navigateToFullCase,
                      ),

                      SelectedLawyerView(
                        lawyer: state.lawyer,
                        onFullProfile: _navigateToFullLawyerProfile,
                        onContact: _navigateToContactLawyer,
                      ),

                      TimelineView(caseEntity: widget.chosenCase),

                      ActionsView(
                        caseEntity: widget.chosenCase,
                        initialComment: state.comment,
                      ),
                    ],
                  ),
                );
              }

              if (state is ErrorCaseDetailsState) {
                return Center(
                  child: Text(
                    "Error: ${state.message}",
                    style: TextStyle(color: ColorPalette.secondaryColor),
                  ),
                );
              }

              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 90,
                  height: 90,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
