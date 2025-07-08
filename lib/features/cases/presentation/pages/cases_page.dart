import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/create_case_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/follow_up_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_event.dart';

class CasesPage extends StatefulWidget {
  const CasesPage({super.key});

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'OPEN',
    'EVALUATION',
    'ACCEPTED',
    'CLOSED',
  ];
  late final String clientId;
  late final String token;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is SuccessAuthState) {
      clientId = authState.user.id;
      token = authState.user.token;
      context.read<CaseBloc>().add(
        GetCasesEvent(clientId: clientId, token: token),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return Colors.blue;
      case 'EVALUATION':
        return Colors.orange;
      case 'ACCEPTED':
        return Colors.green;
      case 'CLOSED':
        return Colors.grey;
      default:
        return ColorPalette.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User header with underline
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User 1', // TODO: Get user name from backend
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: ColorPalette.greyColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'My Cases',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.blackColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorPalette.lighterButtonColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorPalette.blackColor,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorPalette.blackColor,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                    items: _filterOptions.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value == 'All' ? 'All' : value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<CaseBloc, CaseState>(
                  builder: (context, state) {
                    if (state is LoadingCaseState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is LoadedCasesState) {
                      var cases = state.cases;
                      if (_selectedFilter != 'All') {
                        cases = cases
                            .where((c) => c.status.name == _selectedFilter)
                            .toList();
                      }
                      if (cases.isEmpty) {
                        return Center(child: Text('No cases found'));
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: cases.length,
                        itemBuilder: (context, index) {
                          final caseEntity = cases[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Case title
                                  Text(
                                    caseEntity.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.blackColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),

                                  // Case status
                                  Row(
                                    children: [
                                      Text(
                                        'State: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ColorPalette.greyColor,
                                        ),
                                      ),
                                      Text(
                                        caseEntity.status.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(
                                            caseEntity.status.name,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  // Follow Up button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigate to follow up page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (ctx) =>
                                                  CaseDetailsBloc()..add(
                                                    GetCaseDetailsEvent(
                                                      caseId: caseEntity.id,
                                                      token: token,
                                                    ),
                                                  ),
                                              child: FollowUpPage(
                                                chosenCase: caseEntity,
                                                token: token,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorPalette.lighterButtonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Follow Up',
                                        style: TextStyle(
                                          color: ColorPalette.blackColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ErrorCaseState) {
                      return Center(
                        child: Text('Error loading cases: ${state.message}'),
                      );
                    } else {
                      return Center(child: Text('No cases found'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCasePage()),
          );
        },
        backgroundColor: ColorPalette.lighterButtonColor,
        child: Icon(Icons.note_add_outlined, color: ColorPalette.blackColor),
      ),
    );
  }
}
