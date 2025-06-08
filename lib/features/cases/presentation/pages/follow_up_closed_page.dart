import 'package:flutter/material.dart';

class FollowUpClosedPage extends StatefulWidget {
  const FollowUpClosedPage({super.key});

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