import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/views/case_list_view.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class MyCasesPage extends StatefulWidget {
  const MyCasesPage({super.key});

  @override
  State<MyCasesPage> createState() => _MyCasesPageState();
}

class _MyCasesPageState extends State<MyCasesPage> {
  String selectedFilter = "All";

  final List<Client> _client = [
    Client(
      id: 1,
      userId: 1,
      name: 'Jane',
      lastName: 'Doe',
      dni: '12345678',
      username: 'janedoe12',
      image:
          'https://economia3.com/wp-content/uploads/2019/12/Natalia-Juarranz-EQUIPO-HUMANO-450x450.jpg',
    ),
  ];

  final List<Case> _cases = [
    Case(
      id: 1,
      clientId: 1,
      lawyerId: 0,
      title: 'Divorce Case',
      description: 'Divorce case description',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'OPEN_STATUS',
      specialty: 'FAMILY',
      image:
          'https://www.shutterstock.com/image-photo/law-theme-gavel-mallet-judge-600nw-2478909667.jpg',
      applicants: [],
    ),

    Case(
      id: 2,
      clientId: 1,
      lawyerId: 0,
      title: 'Criminal Defense',
      description: 'Criminal case description',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'IN_EVALUATION_STATUS',
      specialty: 'CRIMINAL',
      image:
          'https://media.istockphoto.com/id/1614868242/photo/criminal-talking-to-detective.jpg?s=612x612&w=0&k=20&c=s-d--Z_HIbwCMSzcTafUrN0nxgi2Dqq0W5ISrZoSdOc=',
      applicants: [],
    ),

    Case(
      id: 3,
      clientId: 1,
      lawyerId: 12,
      title: 'Land Dispute',
      description: 'Land dispute case',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'ACCEPTED_STATUS',
      specialty: 'FAMILY',
      image:
          'https://media.istockphoto.com/id/1305460236/vector/two-hands-are-tearing-icon-of-house-concept-of-real-estate-division.jpg?s=612x612&w=0&k=20&c=PiGw89p35wlUF3_T0nN8yHPKgF1a0B2a9-oOfP0MfU8=',
      applicants: [],
    ),

    Case(
      id: 4,
      clientId: 1,
      lawyerId: 22,
      title: 'Labor Case',
      description: 'Labor rights concern',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'CLOSED_STATUS',
      specialty: 'LABOR',
      image:
          'https://www.ilr.cornell.edu/sites/default/files-d8/styles/large_9_5/public/Workers-handboo-800x533.jpg?h=c9f93661&itok=_PmNSZif',
      applicants: [],
    ),
  ];

 final List<Lawyer> _lawyers = [
  Lawyer(
    id: 12,
    userId: 12,
    name: 'John',
    lastName: 'Rivas',
    dni: '87654321',
    phone: '987654321',
    description:
        'Abogado especializado en derecho de familia, con amplia experiencia en casos de custodia, divorcios y acuerdos de visitas.',
    specialty: 'FAMILY_LAW',
    image: 'https://randomuser.me/api/portraits/men/31.jpg',
    rating: 5,
  ),
  Lawyer(
    id: 22,
    userId: 22,
    name: 'Daniel',
    lastName: 'Gonzalez',
    dni: '87654322',
    phone: '987654322',
    description:
        'Abogado especializado en derecho laboral, con vasta experiencia en la defensa de trabajadores y resolución de conflictos laborales.',
    specialty: 'LABOR_LAW',
    image: 'https://randomuser.me/api/portraits/men/32.jpg',
    rating: 4.4,
  ),
];

  List<Case> get filteredCases {
    if (selectedFilter == "All") return _cases;
    return _cases.where((t) => t.status == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final client = _client[0];

    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicAppBar(title: client.username),

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
                        "OPEN_STATUS",
                        "IN_EVALUATION_STATUS",
                        "ACCEPTED_STATUS",
                        "CLOSED_STATUS",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value == "All"
                                ? "All"
                                : value
                                      .split("_")
                                      .join(" ")
                                      .replaceAll("STATUS", ""),
                          ),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(height: 16),

              Expanded(child: CaseListView(cases: filteredCases, client: client, allLawyers: _lawyers,)),

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
