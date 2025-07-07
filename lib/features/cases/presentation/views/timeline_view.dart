import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key, required this.caseEntity});

  final Case caseEntity;

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat('dd/MM/yyyy - hh:mm a');

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // title
            "Timeline",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: ColorPalette.blackColor,
            ),
          ),
          SizedBox(height: 6),

          // events from case
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: ColorPalette.primaryColor,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Case opened at: ${formatedDate.format(caseEntity.createdAt)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 6),

          if (caseEntity.status == CaseStatus.EVALUATION)
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 15,
                      color: ColorPalette.primaryColor,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Moved to Evaluation at: ${formatedDate.format(caseEntity.updatedAt)}", // still working on logic
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorPalette.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          SizedBox(height: 6),


          if (caseEntity.status == CaseStatus.ACCEPTED)
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      size: 15,
                      color: ColorPalette.primaryColor,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Selected Lawyer at: ${formatedDate.format(caseEntity.updatedAt)}", // still working on logic
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorPalette.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          SizedBox(height: 6),


          if (caseEntity.status == CaseStatus.CLOSED)
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: ColorPalette.primaryColor,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Case closed at: ${formatedDate.format(caseEntity.updatedAt)}", // still working on logic
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 6),

          Divider(color: ColorPalette.blackColor, height: 1),

        ],
      ),
    );
  }
}
