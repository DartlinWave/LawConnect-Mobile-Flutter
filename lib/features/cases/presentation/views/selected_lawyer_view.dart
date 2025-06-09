import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class SelectedLawyerView extends StatelessWidget {
  const SelectedLawyerView({
    super.key,
    required this.caseEntity,
    required this.lawyer,
    required this.onFullProfile,
    required this.onContact,
  });

  final Case caseEntity;
  final Lawyer lawyer;
  final VoidCallback onFullProfile;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final statusLabel = {
      "OPEN_STATUS": "Open",
      "IN_EVALUATION_STATUS": "In Evaluation",
      "ACCEPTED_STATUS": "Accepted",
      "CLOSED_STATUS": "Closed",
    };

    final statusColor = {
      "OPEN_STATUS": ColorPalette.openColor,
      "IN_EVALUATION_STATUS": ColorPalette.inEvaluationColor,
      "ACCEPTED_STATUS": ColorPalette.acceptedColor,
      "CLOSED_STATUS": ColorPalette.closedColor,
    };

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
                  image: DecorationImage(image: NetworkImage(lawyer.image)),
                ),
              ),

              SizedBox(width: 12),

              // Name, specialty and rating with stars
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${lawyer.name} ${lawyer.lastName}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      lawyer.specialty.replaceAll("_LAW", ""),
                      style: TextStyle(color: ColorPalette.blackColor),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < lawyer.rating.round()
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
        ],
      ),
    );
  }
}
