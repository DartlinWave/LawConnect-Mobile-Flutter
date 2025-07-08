import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/applicant.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/lawyer_candidate_profile_page.dart';

class SelectedLawyerView extends StatelessWidget {
  final Lawyer? lawyer;
  final List<Lawyer>? postulantLawyers;
  final List<Application>? applications;
  final String customerName;
  final String token;
  final Case caseEntity;
  final VoidCallback? onFullProfile;
  final VoidCallback? onContact;

  const SelectedLawyerView({
    super.key,
    required this.lawyer,
    this.postulantLawyers,
    this.applications,
    required this.customerName,
    required this.token,
    required this.caseEntity,
    this.onFullProfile,
    this.onContact,
  });

  // func to format the lawyer's specialties
  String formatSpecialties(String specialty) {
    final formatSpecialty = specialty.replaceAll("_LAW", "").toLowerCase();
    return formatSpecialty[0].toUpperCase() + formatSpecialty.substring(1);
  }

  // Find the application ID for a specific lawyer
  String? _findApplicationId(String lawyerUserId) {
    if (applications == null) return null;
    try {
      final application = applications!.firstWhere(
        (app) => app.lawyerId == lawyerUserId,
      );
      return application.id.toString();
    } catch (e) {
      return null;
    }
  }

  // Navigate to lawyer candidate profile page
  void _navigateToLawyerProfile(BuildContext context, Lawyer lawyer) {
    final applicationId = _findApplicationId(lawyer.userId);
    if (applicationId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LawyerCandidateProfilePage(
            lawyerId: lawyer.userId, // Use userId for the API call
            applicationId: applicationId,
            customerName: customerName,
            token: token,
            clientId: caseEntity.clientId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not find application for this lawyer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // TODO: implement the option in case there is no selected lawyer and just applicants

  @override
  Widget build(BuildContext context) {
    // PRIMERA PRIORIDAD: Si hay un abogado asignado (casos ACCEPTED/CLOSED), mostrar "Selected Lawyer"
    if (lawyer != null) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selected Lawyer",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: ColorPalette.blackColor,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                // Image of lawyer
                Container(
                  width: 69,
                  height: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // Si hay imagen, usa NetworkImage; si no, color de fondo y un ícono
                    image: lawyer!.image.isNotEmpty
                        ? DecorationImage(image: NetworkImage(lawyer!.image))
                        : null,
                    color: lawyer!.image.isEmpty ? Colors.grey.shade200 : null,
                  ),
                  child: lawyer!.image.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 12),

                // Name, specialty and rating with stars
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${lawyer!.fullName.firstname} ${lawyer!.fullName.lastname}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        // to get all the specialties of the lawyer
                        lawyer!.specialties
                            .map((s) => formatSpecialties(s))
                            .join(", "),
                        style: TextStyle(color: ColorPalette.blackColor),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < lawyer!.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: Color.fromRGBO(247, 193, 16, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Buttons for client to check on the lawyer
                Column(
                  children: [
                    TextButton(
                      onPressed: onFullProfile,
                      style: TextButton.styleFrom(
                        backgroundColor: ColorPalette.lighterButtonColor,
                        foregroundColor: ColorPalette.blackColor,
                      ),
                      child: Text("Full Profile"),
                    ),

                    SizedBox(height: 6),

                    TextButton(
                      onPressed: onContact,
                      style: TextButton.styleFrom(
                        backgroundColor: ColorPalette.lighterButtonColor,
                        foregroundColor: ColorPalette.blackColor,
                      ),
                      child: Text("Contact"),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 18),
            Divider(color: ColorPalette.blackColor, height: 1),
          ],
        ),
      );
    }

    // SEGUNDA PRIORIDAD: Si hay postulantes (casos EVALUATION), mostrar lista de "Postulantes"
    if (postulantLawyers != null && postulantLawyers!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Postulantes",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: ColorPalette.blackColor,
            ),
          ),
          SizedBox(height: 8),
          ...postulantLawyers!.map(
            (lawyer) => GestureDetector(
              onTap: () => _navigateToLawyerProfile(context, lawyer),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen genérica o ícono
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(Icons.person, size: 36, color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Info del abogado
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. ${lawyer.fullName.lastname}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            lawyer.specialties.isNotEmpty
                                ? formatSpecialties(lawyer.specialties.first)
                                : "Especialidad no registrada",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            lawyer.description.length > 50
                                ? '${lawyer.description.substring(0, 50)}...'
                                : lawyer.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < lawyer.rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 18,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // TERCERA PRIORIDAD: No hay abogado asignado ni postulantes (casos OPEN)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Text(
          'No lawyers available yet',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
