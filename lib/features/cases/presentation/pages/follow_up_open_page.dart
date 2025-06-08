import 'package:flutter/material.dart';

class FollowUpOpenPage extends StatefulWidget {
  const FollowUpOpenPage({super.key});

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
          Text(
            'Follow Up Open',
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