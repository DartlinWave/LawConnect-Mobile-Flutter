import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_event.dart' show GetAllLawyersEvent;
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_state.dart';
import 'package:lawconnect_mobile_flutter/features/lawyers/presentation/widgets/card_lawyer_row_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

// ...existing imports...

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
                                description: lawyer.description ?? 'No description available',
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
              onBack: () {
                setState(() {
                  selectedLawyer = null;
                });
              },
            ),
    );
  }
}

// ... LawyerDetailInfo igual que antes ...

class LawyerDetailInfo extends StatelessWidget {
  final dynamic lawyer;
  final VoidCallback onBack;
  const LawyerDetailInfo({required this.lawyer, required this.onBack});


  @override
  Widget build(BuildContext context) {
    int totalStars = lawyer['rating'] as int;
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(lawyer['image']),
          radius: 60, // 120 de diámetro como antes
          backgroundColor: Colors.grey[200],
        ),
        //Estrellas:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalStars, (index) {
            return Icon(Icons.star, color: Colors.amber);
          }),          
        ),
        const SizedBox(height: 10),
        Text(lawyer['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(lawyer['specialty']),
        Text('Rating: ${lawyer['rating']}'),
        const SizedBox(height: 10),
        SizedBox(
          //width: MediaQuery.of(context).size.width,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: lawyer['customers']?.length ?? 0,
            itemBuilder: (context, index) {
              final customer = lawyer['customers'][index];
              debugPrint('Customer: $customer');
              return Container(
                width: 200,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(customer['desc']),
                  ],
                )                
              );
            },
          ),
        ),
        BasicButton(
              text: "Invite to my case",
              onPressed: () {               
                
              },
              width: 275,
              height: 40,
              backgroundColor: ColorPalette.mainButtonColor,
            ),
        ElevatedButton(
          onPressed: onBack,
          child: Text('Regresar'),
        ),
      ],
    );
  }
}
