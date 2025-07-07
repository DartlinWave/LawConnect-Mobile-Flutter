import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class CaseTrackingPage extends StatefulWidget {
  final Map<String, dynamic> caseData;
  
  const CaseTrackingPage({
    super.key,
    required this.caseData,
  });

  @override
  State<CaseTrackingPage> createState() => _CaseTrackingPageState();
}

class _CaseTrackingPageState extends State<CaseTrackingPage> {
  final List<Map<String, dynamic>> _assignedLawyers = []; // Lista vacía por defecto
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssignedLawyers();
  }

  Future<void> _fetchAssignedLawyers() async {
    // TODO: Fetch assigned lawyers from backend based on case ID
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isLoading = false;
      // TODO: Replace with actual data from backend
      // _assignedLawyers = [...]; // This would be populated from the backend
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return ColorPalette.openColor;
      case 'In Evaluation':
        return ColorPalette.inEvaluationColor;
      case 'Accepted':
        return ColorPalette.acceptedColor;
      case 'Closed':
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
        child: SingleChildScrollView(
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
                
                // Summary section
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.blackColor,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Case info and Show Full Case button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorPalette.blackColor,
                              ),
                              children: [
                                TextSpan(
                                  text: '${widget.caseData['title'] ?? 'Case Title'} - State: ',
                                ),
                                TextSpan(
                                  text: widget.caseData['status'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: _getStatusColor(widget.caseData['status'] ?? ''),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.caseData['category'] ?? 'Specialty or category',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorPalette.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    BasicButton(
                      text: "Show Full Case",
                      onPressed: () {
                        // TODO: Navigate to full case details
                        _showFullCase();
                      },
                      width: 140,
                      height: 40,
                      backgroundColor: ColorPalette.extraButtonColor,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Divider line
                Container(
                  height: 1,
                  width: double.infinity,
                  color: ColorPalette.greyColor,
                ),
                
                const SizedBox(height: 24),
                
                // Selected Lawyer section
                Text(
                  'Selected Lawyer',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.blackColor,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Lawyers list or empty state
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _assignedLawyers.isEmpty
                        ? _buildEmptyLawyersState()
                        : _buildLawyersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyLawyersState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Text(
          'There are no available\nlawyers yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: ColorPalette.greyColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLawyersList() {
    return Column(
      children: _assignedLawyers.map((lawyer) => _buildLawyerCard(lawyer)).toList(),
    );
  }

  Widget _buildLawyerCard(Map<String, dynamic> lawyer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.greyColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Lawyer image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(lawyer['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Lawyer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lawyer['name'] ?? 'Unknown Lawyer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lawyer['specialty'] ?? 'General',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette.greyColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lawyer['description'] ?? 'No description available',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette.blackColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Rating stars
                Row(
                  children: List.generate(
                    lawyer['rating'] ?? 0,
                    (index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullCase() {
    // TODO: Navigate to full case details page
    print('Show full case details for: ${widget.caseData['title']}');
    // TODO: Implement navigation to case details page
  }
}