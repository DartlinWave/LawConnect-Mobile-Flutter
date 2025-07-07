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
    // To manage the status with a map for better readability

    final statusLabel = <CaseStatus, String>{
      CaseStatus.OPEN: "Open",
      CaseStatus.EVALUATION: "Evaluation",
      CaseStatus.ACCEPTED: "Accepted",
      CaseStatus.CLOSED: "Closed",
    };

    final statusColor = <CaseStatus, Color>{
      CaseStatus.OPEN: ColorPalette.openColor,
      CaseStatus.EVALUATION: ColorPalette.inEvaluationColor,
      CaseStatus.ACCEPTED: ColorPalette.acceptedColor,
      CaseStatus.CLOSED: ColorPalette.closedColor,
    };

    return Card(
      color: ColorPalette.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: ColorPalette.primaryColor, width: 1),
      ),

      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              caseEntity.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Hero(
                tag: caseEntity.id,
                child: Image.network(caseEntity.image, fit: BoxFit.contain),
              ),
            ),

            SizedBox(height: 8),

            Center(
              child: Text.rich(
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
            ),
            if (caseEntity.status == CaseStatus.EVALUATION)
              Text(
                "Applications received: ${caseEntity.applicationsCount ?? 1}",
                style: TextStyle(color: ColorPalette.blackColor),
              ),

            SizedBox(height: 8),

            BasicButton(
              text: "Follow Up",
              onPressed: onFollowUpToCase,
              width: 103,
              height: 34,
              backgroundColor: ColorPalette.extraButtonColor,
            ),
          ],
        ),
      ),
    );
  }
}
