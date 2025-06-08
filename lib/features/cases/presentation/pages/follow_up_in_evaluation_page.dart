import 'package:flutter/material.dart';

class FollowUpInEvaluationPage extends StatefulWidget {
  const FollowUpInEvaluationPage({super.key});

  @override
  State<FollowUpInEvaluationPage> createState() => _FollowUpInEvaluationPageState();
}

class _FollowUpInEvaluationPageState extends State<FollowUpInEvaluationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Up In Evaluation',
          ),
          const SizedBox(height: 16.0),
          Text(
            'This page is under construction.',
          ),
        ],
      ),
    );
  }
}