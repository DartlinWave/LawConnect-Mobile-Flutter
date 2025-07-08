import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

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
      elevation: 4,
      color: ColorPalette.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ColorPalette.primaryColor, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                caseEntity.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            if (caseEntity.image.isNotEmpty)
              Flexible(
                child: SizedBox(
                  height: 60,
                  child: Hero(
                    tag: caseEntity.id,
                    child: Image.network(
                      caseEntity.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "State: ",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
                Flexible(
                  child: Text(
                    statusLabel[caseEntity.status] ?? "ERROR",
                    style: TextStyle(
                      color:
                          statusColor[caseEntity.status] ??
                          ColorPalette.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (caseEntity.status == CaseStatus.EVALUATION)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  "Applications received: ${caseEntity.applicationsCount ?? 1}",
                  style: TextStyle(
                    color: ColorPalette.blackColor,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onFollowUpToCase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.extraButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text("Follow Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
