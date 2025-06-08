import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class FollowUpOpenPage extends StatefulWidget {
  const FollowUpOpenPage({super.key, required this.caseEntity});

  final Case caseEntity;

  @override
  State<FollowUpOpenPage> createState() => _FollowUpOpenPageState();
}

class _FollowUpOpenPageState extends State<FollowUpOpenPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Follow Up Open'),
          const SizedBox(height: 16.0),
          Text('This page is under construction.'),
        ],
      ),
    );
  }
}
