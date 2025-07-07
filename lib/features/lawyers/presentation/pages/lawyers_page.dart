import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_event.dart' show GetAllLawyersEvent;
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_state.dart';
import 'package:lawconnect_mobile_flutter/features/lawyers/presentation/widgets/card_lawyer_row_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';
import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';

class LawyersPage extends StatefulWidget {
  const LawyersPage({super.key});

  @override
  State<LawyersPage> createState() => _LawyersPageState();
}

class _LawyersPageState extends State<LawyersPage> {
  String? selectedValue = 'Civil';
  final List<String> items = ['Penalista', 'Civil', 'Familiar', 'Laboral', 'Mercantil'];
  String _lawyerName = '';
  dynamic selectedLawyer;

  // Customers en duro por nombre de abogado
  final Map<String, List<Map<String, String>>> lawyerCustomers = {
    'Dr Rivas': [
      {'name': 'Laura', 'desc': 'excelente abogado, muy profesional', 'image': 'https://randomuser.me/api/portraits/women/1.jpg'},
      {'name': 'Josi', 'desc': 'muy paciente y comprensivo, me ayudó mucho', 'image': 'https://randomuser.me/api/portraits/women/2.jpg'},
      {'name': 'Ana', 'desc': 'me ayudó a ganar mi caso, muy recomendable', 'image': 'https://randomuser.me/api/portraits/women/3.jpg'},
      {'name': 'Carla', 'desc': 'muy profesional y atento, me sentí muy apoyada', 'image': 'https://randomuser.me/api/portraits/women/4.jpg'},
    ],
    'Dr Jane': [
      {'name': 'Pedro', 'desc': 'Muy buena abogada, resolvió mi caso familiar.', 'image': 'https://randomuser.me/api/portraits/men/1.jpg'},
      {'name': 'Lucía', 'desc': 'Excelente trato y resultados.', 'image': 'https://randomuser.me/api/portraits/women/5.jpg'},
    ],
    'Dr John': [
      {'name': 'Carlos', 'desc': 'Buen abogado, aunque algo serio.', 'image': 'https://randomuser.me/api/portraits/men/2.jpg'},
    ],
    'Dr Smith': [
      {'name': 'Marta', 'desc': 'Me ayudó con un tema civil complicado.', 'image': 'https://randomuser.me/api/portraits/women/6.jpg'},
    ],
    'Dr Alice': [
      {'name': 'Sofía', 'desc': 'Muy profesional y clara.', 'image': 'https://randomuser.me/api/portraits/women/7.jpg'},
    ],
    'Dr Bob': [
      {'name': 'Luis', 'desc': 'Buen trato y atención.', 'image': 'https://randomuser.me/api/portraits/men/3.jpg'},
    ],
  };

  @override
  void initState() {
    context.read<LawyerBloc>().add(GetAllLawyersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: selectedLawyer == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Your Lawyer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: ColorPalette.primaryColor,
                  thickness: 1,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedValue,
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lawyerName = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter text',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BasicButton(
                  text: "Search",
                  onPressed: () {
                    setState(() {});
                  },
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  backgroundColor: ColorPalette.mainButtonColor,
                ),
                Expanded(
                  child: BlocBuilder<LawyerBloc, LawyerState>(
                    builder: (context, state) {
                      if (state is InitialLawyerState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LoadedLawyerState) {
                        final filteredLawyers = state.lawyers.where((lawyer) {
                          final matchesSpecialty = selectedValue == null || lawyer.specialty == selectedValue;
                          final matchesName = _lawyerName.isEmpty || lawyer.name.toLowerCase().contains(_lawyerName.toLowerCase());
                          return matchesSpecialty && matchesName;
                        }).toList();

                        if (filteredLawyers.isEmpty) {
                          return const Center(child: Text('No lawyers found.'));
                        }

                        return ListView.builder(
                          itemCount: filteredLawyers.length,
                          itemBuilder: (context, index) {
                            final lawyer = filteredLawyers[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLawyer = lawyer;
                                });
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
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            )
          : LawyerDetailInfo(
              lawyer: selectedLawyer,
              customers: lawyerCustomers[selectedLawyer.name] ?? [],
              onBack: () {
                setState(() {
                  selectedLawyer = null;
                });
              },
            ),
    );
  }
}

class LawyerDetailInfo extends StatelessWidget {
  final Lawyer lawyer;
  final List<Map<String, String>> customers;
  final VoidCallback onBack;
  const LawyerDetailInfo({super.key, required this.lawyer, required this.customers, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagen rectangular de ancho completo
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              lawyer.image,
              width: MediaQuery.of(context).size.width,
              height: 290,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y especialidad a la izquierda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lawyer.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(lawyer.specialty, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Rating (estrellas) a la derecha
              Column(
                children: [
                  Row(
                    children: List.generate(lawyer.rating, (index) {
                      return const Icon(Icons.star, color: Colors.amber, size: 22);
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Descripción abajo de todo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            lawyer.description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        // Carrusel de customers
        if (customers.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(customer['image'] ?? ''),
                          radius: 22,
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(customer['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text("customer", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 6),
                              Text(
                                customer['desc'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        BasicButton(
          text: "Invite to my case",
          onPressed: () {},
          width: 275,
          height: 40,
          backgroundColor: ColorPalette.mainButtonColor,
        ),
        ElevatedButton(
          onPressed: onBack,
          child: const Text('Regresar'),
        ),
      ],
    );
  }
}
