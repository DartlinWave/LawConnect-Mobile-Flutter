import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/actions_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/selected_lawyer_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/summary_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/timeline_view.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/case_detail_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/assigned_lawyer_profile_page.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({
    super.key,
    required this.chosenCase,
    required this.token,
  });

  final Case chosenCase;
  final String token;

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  void _navigateToFullCase() {
    // Navigate to the new case detail page
    final authState = context.read<AuthBloc>().state;
    final customerName = authState is SuccessAuthState
        ? authState.user.username
        : "Unknown User";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaseDetailPage(
          caseEntity: widget.chosenCase,
          customerName: customerName,
        ),
      ),
    );
  }

  void _navigateToFullLawyerProfile() {
    final state = context.read<CaseDetailsBloc>().state;
    if (state is LoadedCaseDetailsState && state.lawyer != null) {
      // Navigate to dedicated assigned lawyer profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssignedLawyerProfilePage(
            lawyer: state.lawyer!,
            customerName: state.user.username,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No lawyer information available'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToContactLawyer() {
    // For now, show a message that this feature is not implemented
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact lawyer feature coming soon'),
        duration: Duration(seconds: 2),
      ),
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
          child: BlocListener<CaseDetailsBloc, CaseDetailsState>(
            listener: (context, state) {
              if (state is FinishCaseState) {
                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Case successfully closed."),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                // Delay for a better UX experience, then navigate back
                Future.delayed(Duration(seconds: 2), () {
                  if (mounted) {
                    Navigator.pop(
                      context,
                      true,
                    ); // Return true to indicate successful closure
                  }
                });
              } else if (state is ErrorCaseDetailsState &&
                  state.message.contains('close case')) {
                // Show an error message specifically for case closure failures
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to close case: ${state.message}"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },

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
                          postulantLawyers: state.postulantLawyers,
                          applications: state.applications,
                          customerName: clientUsername,
                          token: widget.token,
                          caseEntity: widget.chosenCase,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ocurrió un error:\n${state.message}",
                          style: TextStyle(
                            color: ColorPalette.secondaryColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Icon(
                          Icons.error_outline,
                          color: ColorPalette.secondaryColor,
                          size: 48,
                        ),
                        SizedBox(height: 24),
                        BackButton(
                          color: ColorPalette.blackColor,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
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
      ),
    );
  }
}
