import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class SelectedLawyerView extends StatelessWidget {
  final Lawyer? lawyer;
  final List<Lawyer>? postulantLawyers;
  final VoidCallback? onFullProfile;
  final VoidCallback? onContact;

  const SelectedLawyerView({
    Key? key,
    required this.lawyer,
    this.postulantLawyers,
    this.onFullProfile,
    this.onContact,
  }) : super(key: key);

  // func to format the lawyer's specialties
  String formatSpecialties(String specialty) {
    final formatSpecialty = specialty.replaceAll("_LAW", "").toLowerCase();
    return formatSpecialty[0].toUpperCase() + formatSpecialty.substring(1);
  }

  // TODO: implement the option in case there is no selected lawyer and just applicants

  @override
  Widget build(BuildContext context) {
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
            (lawyer) => Container(
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
        ],
      );
    }

    // Si hay postulantes pero la lista está vacía (error al obtener abogados)
    if (postulantLawyers != null && postulantLawyers!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 48),
              SizedBox(height: 16),
              Text(
                'Hay postulaciones disponibles\npero no se pueden mostrar los abogados',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Por favor, intenta más tarde',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (lawyer == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            'There are no available\nlawyers yet',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }
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
                        child: Icon(Icons.person, size: 36, color: Colors.grey),
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
}
