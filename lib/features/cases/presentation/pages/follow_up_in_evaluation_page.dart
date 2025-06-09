import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class FollowUpInEvaluationPage extends StatefulWidget {
  const FollowUpInEvaluationPage({super.key, required this.caseEntity});

  final Case caseEntity;

  @override
  State<FollowUpInEvaluationPage> createState() =>
      _FollowUpInEvaluationPageState();
}

class _FollowUpInEvaluationPageState extends State<FollowUpInEvaluationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Follow Up In Evaluation",
              style: TextStyle(
                color: ColorPalette.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "This page is under construction.",
              style: TextStyle(
                color: ColorPalette.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),

            BackButton(
              onPressed: () {
                // it's just temporary, it will be replaced with the content of the page
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
