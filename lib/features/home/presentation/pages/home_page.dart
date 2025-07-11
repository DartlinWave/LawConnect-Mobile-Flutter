import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_event.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_state.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/widgets/card_doctor_view.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/lawyers/presentation/pages/lawyer_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  List<dynamic> comments = []; //otra llmada a la bd

  //POR HACER: move a repositorio.
  // Future<void> loadLawyers() async {
  //   final String response = await rootBundle.loadString('assets/doctors.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     listLawyers = data;
  //   });
  // }

  //obtener data desde el servidor:
  // Future<List<Lawyer>> fetchLawyers() async {
  //   final response = await http.get(Uri.parse('https://api.example.com/lawyers'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => Lawyer.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load lawyers');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Welcome Client!"),
          ),
          // linea separadora
          Divider(color: ColorPalette.primaryColor, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Suggested Laywers",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorPalette.primaryColor,
              ),
            ),
          ),
          BlocBuilder<LawyerBloc, LawyerState>(
            builder: (context, state) {
              if (state is LoadingLawyerState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedLawyerState) {
                return Carrusel(
                  listLawyers: state.lawyers,
                  child: Text("Suggested Laywers"),
                );
              } else if (state is ErrorLawyerState) {
                return Center(
                  child: Column(
                    children: [
                      Text('Error loading lawyers: ${state.message}'),
                      ElevatedButton(
                        onPressed: () {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is SuccessAuthState) {
                            context.read<LawyerBloc>().add(
                              GetAllLawyersEvent(token: authState.user.token),
                            );
                          }
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return Center();
            },
          ),
          //Carrusel(child: Text("Suggestes Laywers"), listLawyers: listLawyers),
        ],
      ),
    );
  }
}

class Carrusel extends StatelessWidget {
  final Widget child;
  final List<Lawyer> listLawyers;

  const Carrusel({super.key, required this.child, required this.listLawyers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listLawyers.length,
          itemBuilder: (context, index) {
            final lawyer = listLawyers[index];

            // una búsqueda de todo slo comentarios de abogado usando la var comments
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
              child: CardDoctorView(
                name: lawyer.name,
                specialty: lawyer.specialty,
                rating: lawyer.rating.toString(),
                imageUrl: lawyer.image,
              ),
            );
          },
        ),
      ),
    );
  }
}
