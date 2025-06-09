import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class FollowUpClosedPage extends StatefulWidget {
  const FollowUpClosedPage({super.key, required this.caseEntity, required this.client, required this.lawyer});

  final Case caseEntity;
  final Client client;
  final Lawyer lawyer;


  @override
  State<FollowUpClosedPage> createState() => _FollowUpClosedPageState();
}

class _FollowUpClosedPageState extends State<FollowUpClosedPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Up Closed',
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