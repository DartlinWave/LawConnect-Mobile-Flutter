import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class CaseCardView extends StatelessWidget {
  const CaseCardView({
    super.key,
    required this.caseEntity,
    required this.onFollowUpToCase,
  });

  // There is already a "case" word reserved in Dart, so we use "caseEntity" to avoid confusion.

  final Case caseEntity;
  final VoidCallback onFollowUpToCase;

  @override
  Widget build(BuildContext context) {
    // To manage the status

    final statusLabel = {
      "OPEN": "Open",
      "IN_EVALUATION": "In Evaluation",
      "ACCEPTED": "Accepted",
      "CLOSED": "Closed",
    };

    final statusColor = {
      "OPEN": ColorPalette.openColor,
      "IN_EVALUATION": ColorPalette.inEvaluationColor,
      "ACCEPTED": ColorPalette.acceptedColor,
      "CLOSED": ColorPalette.closedColor,
    };

    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              caseEntity.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Hero(
                tag: caseEntity.id,
                child: Image.network(caseEntity.image, fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: 8),

            Text.rich(
              TextSpan(
                text: "State: ",
                children: [
                  TextSpan(
                    text: statusLabel[caseEntity.status] ?? "ERROR",
                    style: TextStyle(
                      color:
                          statusColor[caseEntity.status] ??
                          ColorPalette.blackColor,
                    ),
                  ),
                ],
              ),
            ),
            if (caseEntity.status == "IN_EVALUATION")
              Text(
                "Applications received: ${caseEntity.applicants.length}",
                style: TextStyle(color: ColorPalette.blackColor),
              ),

            SizedBox(height: 8),

            BasicButton(
              text: "Follow Up",
              onPressed: onFollowUpToCase,
              width: 103,
              height: 34,
              backgroundColor: ColorPalette.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
