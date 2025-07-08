import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_event.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_state.dart';
import 'package:lawconnect_mobile_flutter/features/lawyers/presentation/widgets/card_lawyer_row_view.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/lawyers/presentation/pages/lawyer_profile_page.dart';

class LawyersPage extends StatefulWidget {
  const LawyersPage({super.key});

  @override
  State<LawyersPage> createState() => _LawyersPageState();
}

class _LawyersPageState extends State<LawyersPage> {
  @override
  void initState() {
    super.initState();
    // Get token from AuthBloc and load lawyers
    final authState = context.read<AuthBloc>().state;
    if (authState is SuccessAuthState) {
      context.read<LawyerBloc>().add(
        GetAllLawyersEvent(token: authState.user.token),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "All Lawyers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.primaryColor,
                ),
              ),
            ),
            Divider(color: ColorPalette.primaryColor, thickness: 1),
            Expanded(
              child: BlocBuilder<LawyerBloc, LawyerState>(
                builder: (context, state) {
                  if (state is LoadingLawyerState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadedLawyerState) {
                    if (state.lawyers.isEmpty) {
                      return const Center(child: Text('No lawyers available'));
                    }
                    return LawyersList(listLawyers: state.lawyers);
                  } else if (state is ErrorLawyerState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error loading lawyers: ${state.message}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final authState = context.read<AuthBloc>().state;
                              if (authState is SuccessAuthState) {
                                context.read<LawyerBloc>().add(
                                  GetAllLawyersEvent(
                                    token: authState.user.token,
                                  ),
                                );
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  // Estado inicial o desconocido
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LawyersList extends StatelessWidget {
  final List<Lawyer> listLawyers;

  const LawyersList({super.key, required this.listLawyers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Al estar dentro de un Expanded, no necesitamos shrinkWrap
      // y podemos permitir que el ListView maneje su propio scroll
      itemCount: listLawyers.length,
      itemBuilder: (context, index) {
        final lawyer = listLawyers[index];
        return InkWell(
          onTap: () {
            // Navigate to lawyer profile page with lawyer data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LawyerProfilePage(
                  lawyerData: {
                    'name': lawyer.name,
                    'specialty': lawyer.specialty,
                    'rating': lawyer.rating,
                    'description': lawyer.description,
                    'image': lawyer.image,
                  },
                ),
              ),
            );
          },
          child: CardLawyerRowView(
            name: lawyer.name,
            specialty: lawyer.specialty,
            rating: lawyer.rating.toString(),
            description: lawyer.description,
            imageUrl: lawyer.image,
          ),
        );
      },
    );
  }
}
