import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key, required this.chosenCase, required this.client});

  final Case chosenCase;
  final Client client;

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Follow Up",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Case Title: ${widget.chosenCase.title}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                "Client Name: ${widget.client.fullName}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
