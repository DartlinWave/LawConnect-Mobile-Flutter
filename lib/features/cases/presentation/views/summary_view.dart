import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key, required this.caseEntity});

  final Case caseEntity;

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
          Text("Summary", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: ColorPalette.blackColor)),
          SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: "${caseEntity.title} – State: ",
              style: TextStyle(color: ColorPalette.blackColor),
              children: [
                TextSpan(
                  text: statusLabel[caseEntity.status] ?? "Unknown",
                  style: TextStyle(
                    color: statusColor[caseEntity.status] ?? ColorPalette.blackColor,
                  ),
                ),
              ],
            ),
          ),
          Text(caseEntity.specialty.toLowerCase()),
          SizedBox(height: 12),
          Divider(color: ColorPalette.blackColor, height: 1),
        ],
      ),
      );
  }
}
