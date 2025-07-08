import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({
    super.key,
    required this.caseEntity,
    required this.onShowFullCase,
  });

  final Case caseEntity;
  final VoidCallback onShowFullCase;

  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Summary",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: ColorPalette.blackColor,
            ),
          ),
          SizedBox(height: 4),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: "${caseEntity.title} – State: ",
                  style: TextStyle(color: ColorPalette.blackColor),
                  children: [
                    TextSpan(
                      text: statusLabel[caseEntity.status] ?? "Unknown",
                      style: TextStyle(
                        color:
                            statusColor[caseEntity.status] ??
                            ColorPalette.blackColor,
                      ),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onShowFullCase,
                  style: TextButton.styleFrom(
                    backgroundColor: ColorPalette.lighterButtonColor,
                    foregroundColor: ColorPalette.blackColor,
                  ),
                  child: Text("Show Full Case"),
                ),
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
