import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class AssignedLawyerProfilePage extends StatelessWidget {
  const AssignedLawyerProfilePage({
    super.key,
    required this.lawyer,
    required this.customerName,
  });

  final Lawyer lawyer;
  final String customerName;

  String formatSpecialties(String specialty) {
    final formatSpecialty = specialty.replaceAll("_LAW", "").toLowerCase();
    return formatSpecialty[0].toUpperCase() + formatSpecialty.substring(1);
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
              // Header with user name and underline
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
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

              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorPalette.blackColor,
                    ),
                  ),
                  Text(
                    'Assigned Lawyer Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.blackColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Lawyer profile content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lawyer image and basic info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Lawyer image
                          Container(
                            width: 120,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: lawyer.image.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(lawyer.image),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: lawyer.image.isEmpty
                                  ? Colors.grey.shade200
                                  : null,
                            ),
                            child: lawyer.image.isEmpty
                                ? Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                          ),

                          const SizedBox(width: 20),

                          // Basic info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dr. ${lawyer.fullName.firstname} ${lawyer.fullName.lastname}",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.blackColor,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  lawyer.specialties.isNotEmpty
                                      ? lawyer.specialties
                                            .map((s) => formatSpecialties(s))
                                            .join(", ")
                                      : "Especialidad no registrada",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Rating
                                Row(
                                  children: [
                                    ...List.generate(5, (i) {
                                      return Icon(
                                        i < lawyer.rating.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 20,
                                      );
                                    }),
                                    const SizedBox(width: 8),
                                    Text(
                                      lawyer.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Contact info
                                Text(
                                  "Assigned lawyer for this case",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Description section
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.blackColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        lawyer.description.isNotEmpty
                            ? lawyer.description
                            : "No description available",
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorPalette.blackColor,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Contact information section
                      Text(
                        "Contact Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.blackColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildContactInfo(
                        "Phone",
                        lawyer.contactInfo.phoneNumber,
                      ),
                      _buildContactInfo("Address", lawyer.contactInfo.address),

                      const SizedBox(height: 32),

                      // Specialties section
                      if (lawyer.specialties.isNotEmpty) ...[
                        Text(
                          "Specialties",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.blackColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: lawyer.specialties.map((specialty) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorPalette.lighterButtonColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                formatSpecialties(specialty),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorPalette.blackColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Contact button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: BasicButton(
                  text: "Contact Lawyer",
                  onPressed: () {
                    // TODO: Implement contact functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Contact feature coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  width: double.infinity,
                  height: 48,
                  backgroundColor: ColorPalette.matchButtonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorPalette.blackColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Not provided",
              style: TextStyle(
                fontSize: 16,
                color: value.isNotEmpty ? ColorPalette.blackColor : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
