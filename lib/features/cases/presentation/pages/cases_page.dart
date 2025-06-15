import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/create_case_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/case_tracking_page.dart';

class CasesPage extends StatefulWidget {
  const CasesPage({super.key});

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Open',
    'In Evaluation',
    'Accepted',
    'Closed'
  ];
  
  // TODO: Replace with actual data from backend
  final List<Map<String, dynamic>> _cases = []; // Lista vacía como estaba originalmente
  
  @override
  void initState() {
    super.initState();
    // TODO: Fetch cases from backend
    _fetchCases();
  }
  
  Future<void> _fetchCases() async {
    // TODO: Implement API call to fetch cases
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For now, we'll leave the cases list empty to show the empty state
    setState(() {
      // _cases = [...]; // This would be populated from the backend
    });
  }
  
  List<Map<String, dynamic>> get _filteredCases {
    if (_selectedFilter == 'All') {
      return _cases;
    }
    return _cases.where((caseItem) => caseItem['status'] == _selectedFilter).toList();
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
              Container(
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
              
              // My Cases title
              Text(
                'My Cases',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.blackColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Filter dropdown
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Cases list or empty state
              Expanded(
                child: _filteredCases.isEmpty
                    ? _buildEmptyState()
                    : _buildCasesList(),
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
        child: Icon(
          Icons.note_add_outlined,
          color: ColorPalette.blackColor,
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'There are no available\ncases yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: ColorPalette.greyColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCasesList() {
    return ListView.builder(
      itemCount: _filteredCases.length,
      itemBuilder: (context, index) {
        final caseItem = _filteredCases[index];
        return _buildCaseCard(caseItem);
      },
    );
  }
  
  Widget _buildCaseCard(Map<String, dynamic> caseItem) {
    Color statusColor;
    switch (caseItem['status']) {
      case 'Open':
        statusColor = ColorPalette.openColor;
        break;
      case 'In Evaluation':
        statusColor = ColorPalette.inEvaluationColor;
        break;
      case 'Accepted':
        statusColor = ColorPalette.acceptedColor;
        break;
      case 'Closed':
        statusColor = ColorPalette.closedColor;
        break;
      default:
        statusColor = ColorPalette.greyColor;
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to case tracking page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaseTrackingPage(caseData: caseItem),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caseItem['title'] ?? 'Untitled Case',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                caseItem['description'] ?? 'No description',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorPalette.greyColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  caseItem['status'] ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}