import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class FollowUpAcceptedPage extends StatefulWidget {
  const FollowUpAcceptedPage({super.key, required this.caseEntity});

  final Case caseEntity;

  @override
  State<FollowUpAcceptedPage> createState() => _FollowUpAcceptedPageState();
}

class _FollowUpAcceptedPageState extends State<FollowUpAcceptedPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Up Accepted',
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