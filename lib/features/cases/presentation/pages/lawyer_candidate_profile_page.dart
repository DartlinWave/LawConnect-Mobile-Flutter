import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/person_name.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/contact_info.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LawyerCandidateProfilePage extends StatefulWidget {
  const LawyerCandidateProfilePage({
    super.key,
    required this.lawyerId,
    required this.applicationId,
    required this.customerName,
    required this.token,
    required this.clientId,
  });

  final String lawyerId;
  final String applicationId;
  final String customerName;
  final String token;
  final String clientId;

  @override
  State<LawyerCandidateProfilePage> createState() =>
      _LawyerCandidateProfilePageState();
}

class _LawyerCandidateProfilePageState
    extends State<LawyerCandidateProfilePage> {
  bool _isLoading = true;
  Lawyer? _lawyer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLawyerProfile();
  }

  Future<void> _loadLawyerProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Real API call to get lawyer profile
      final response = await http.get(
        Uri.parse(
          'https://lawconnect-backend-y48f.onrender.com/api/v1/lawyers/${widget.lawyerId}',
        ),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _lawyer = Lawyer(
            id: data['id'] ?? '',
            userId: data['userId'] ?? widget.lawyerId,
            fullName: PersonName(
              firstname: data['fullName']?['firstname'] ?? '',
              lastname: data['fullName']?['lastname'] ?? 'Unknown',
            ),
            dni: data['dni'] ?? '',
            contactInfo: ContactInfo(
              phoneNumber: data['contactInfo']?['phoneNumber'] ?? '',
              address: data['contactInfo']?['address'] ?? '',
            ),
            description: data['description'] ?? 'No description available',
            specialties: data['specialties']?.cast<String>() ?? <String>[],
            image: data['image'] ?? '',
            rating: (data['rating'] ?? 0).toDouble(),
          );
          _isLoading = false;
        });
      } else {
        throw Exception(
          'Failed to load lawyer profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptApplication(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: ColorPalette.primaryColor),
        ),
      );

      // Real API call to accept application
      final uri = Uri.parse(
        'https://lawconnect-backend-y48f.onrender.com/api/v1/applications/${widget.applicationId}/accept',
      ).replace(queryParameters: {'clientId': widget.clientId});

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      // Hide loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application accepted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to the main Cases view after successful acceptance
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(initialIndex: 2),
          ),
          (route) => false,
        );
      } else {
        throw Exception('Failed to accept application: ${response.statusCode}');
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting application: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectApplication(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: ColorPalette.primaryColor),
        ),
      );

      // Real API call to reject application
      final uri = Uri.parse(
        'https://lawconnect-backend-y48f.onrender.com/api/v1/applications/${widget.applicationId}/reject',
      ).replace(queryParameters: {'clientId': widget.clientId});

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      // Hide loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application rejected'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context, false); // Return false to indicate rejection
      } else {
        throw Exception('Failed to reject application: ${response.statusCode}');
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting application: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
              // Back button
              IconButton(
                icon: Icon(Icons.arrow_back, color: ColorPalette.blackColor),
                onPressed: () => Navigator.pop(context),
                alignment: Alignment.centerLeft,
              ),

              // Customer name with underline
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customerName,
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

              // Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.primaryColor,
                        ),
                      )
                    : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading lawyer profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: ColorPalette.blackColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorPalette.greyColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            BasicButton(
                              text: "Retry",
                              onPressed: _loadLawyerProfile,
                              backgroundColor: ColorPalette.primaryColor,
                              width: 120,
                              height: 40,
                            ),
                          ],
                        ),
                      )
                    : _lawyer == null
                    ? Center(
                        child: Text(
                          'No lawyer data available',
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorPalette.greyColor,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Lawyer profile card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  // Profile image placeholder
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: _lawyer!.image.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              _lawyer!.image,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.person,
                                                    size: 60,
                                                    color: Colors.grey.shade600,
                                                  ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey.shade600,
                                          ),
                                  ),

                                  const SizedBox(height: 16), // Lawyer name
                                  Text(
                                    "Dr. ${_lawyer!.fullName.lastname}",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.blackColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 8),

                                  // Specialty
                                  Text(
                                    _lawyer!.specialties.isNotEmpty
                                        ? _lawyer!.specialties.first
                                              .replaceAll('_LAW', '')
                                              .toLowerCase()
                                              .split(' ')
                                              .map(
                                                (word) =>
                                                    word[0].toUpperCase() +
                                                    word.substring(1),
                                              )
                                              .join(' ')
                                        : 'General',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ColorPalette.greyColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 12),

                                  // Rating stars
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < _lawyer!.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 24,
                                      );
                                    }),
                                  ),

                                  const SizedBox(height: 20),

                                  // Description
                                  Text(
                                    _lawyer!.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorPalette.blackColor,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
              ),

              // Action buttons (always visible when not loading)
              if (!_isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      // Decline button
                      Expanded(
                        child: BasicButton(
                          text: "Decline",
                          onPressed: () => _rejectApplication(context),
                          width: double.infinity,
                          height: 50,
                          backgroundColor: Colors.red,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Match button
                      Expanded(
                        child: BasicButton(
                          text: "Match",
                          onPressed: () => _acceptApplication(context),
                          width: double.infinity,
                          height: 50,
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
