import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

abstract class CaseState {
  const CaseState();
}

class InitialCaseState extends CaseState {}

class LoadingCaseState extends CaseState {}

class LoadedCasesState extends CaseState {
  final List<Case> cases;

  const LoadedCasesState({required this.cases});
}

class ErrorCaseState extends CaseState {
  final String message;

  const ErrorCaseState({required this.message});
}