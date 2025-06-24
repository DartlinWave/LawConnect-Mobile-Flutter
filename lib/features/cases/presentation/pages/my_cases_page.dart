import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_list_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class MyCasesPage extends StatefulWidget {
  const MyCasesPage({super.key});

  @override
  State<MyCasesPage> createState() => _MyCasesPageState();
}

class _MyCasesPageState extends State<MyCasesPage> {
  String selectedFilter = "All";
  late final String clientId;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;



    if (authState is SuccessAuthState) {
      clientId = authState.user.id;
      context.read<CaseBloc>().add(GetCasesEvent(clientId: clientId));
    } 
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;


// to get the username of the client considering the information from the sign in
    final clientUsername = authState is SuccessAuthState
        ? authState.user.username
        : "Unknown User";

    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicAppBar(title: clientUsername),

              SizedBox(height: 16),

              Text(
                "My Cases",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.blackColor,
                ),
              ),

              SizedBox(height: 8),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
                  items:
                      <String>[
                        "All",
                        "OPEN",
                        "EVALUATION",
                        "ACCEPTED",
                        "CLOSED",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value == "All"
                                ? "All"
                                : value
                          ),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<CaseBloc, CaseState>(
                  builder: (context, state) {
                    if (state is LoadingCaseState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is LoadedCasesState) {
                      List<Case> cases = state.cases;

                      if (selectedFilter != "All") {
                        cases = cases.where((c) => c.status.name == selectedFilter).toList();
                      }

                      return CaseListView(cases: cases);
                    } else if (state is ErrorCaseState) {
                      return Center(child: Text("Error loading cases"));
                    } else {
                      return Center(child: Text("No cases found"));
                    }
                  },
                ),
              ),

              FloatingActionButton(
                onPressed: () {
                  // Todo: button functionality for new case
                },
                backgroundColor: ColorPalette.lighterButtonColor,
                child: Icon(Icons.note_add, color: ColorPalette.blackColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
