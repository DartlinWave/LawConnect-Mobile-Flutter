import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.cases });

  final List<Case> cases;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(gridDelegate: , itemBuilder: itemBuilder)
  }
}