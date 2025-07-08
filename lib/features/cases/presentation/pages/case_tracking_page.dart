import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';

class CaseTrackingPage extends StatefulWidget {
  final String status;
  final String token;
  const CaseTrackingPage({
    super.key,
    required this.status,
    required this.token,
  });
  @override
  State<CaseTrackingPage> createState() => _CaseTrackingPageState();
}

class _CaseTrackingPageState extends State<CaseTrackingPage> {
  @override
  void initState() {
    super.initState();
    context.read<CaseBloc>().add(
      GetCasesByStatusEvent(status: widget.status, token: widget.token),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'OPEN':
        return ColorPalette.openColor;
      case 'EVALUATION':
        return ColorPalette.inEvaluationColor;
      case 'ACCEPTED':
        return ColorPalette.acceptedColor;
      case 'CLOSED':
        return ColorPalette.closedColor;
      default:
        return ColorPalette.greyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: BlocBuilder<CaseBloc, CaseState>(
          builder: (context, state) {
            if (state is LoadingCaseState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedCasesState) {
              final cases = state.cases;
              if (cases.isEmpty) {
                return Center(child: Text('No cases found for this status'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  final caseEntity = cases[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        '${caseEntity.title} - State: ${caseEntity.status}',
                      ),
                      subtitle: Text(caseEntity.description ?? ''),
                      trailing: TextButton(
                        child: const Text('Show Full Case'),
                        onPressed: () {
                          // Navegar a la pantalla de detalles o seguimiento
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is ErrorCaseState) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Select a status to view cases.'));
          },
        ),
      ),
    );
  }
}
