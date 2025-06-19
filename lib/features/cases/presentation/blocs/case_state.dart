import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

abstract class CaseState {
  const CaseState();
}

class InitialCaseState extends CaseState {}

class LoadingCaseState extends CaseState {}

class LoadedCasesState extends CaseState {
  final List<Case> cases;

  const LoadedCasesState({required this.cases});
}

class LoadedCaseDetailsState extends CaseState {
  final Case caseEntity;
  final Lawyer lawyer;
  final Comment comment;

  const LoadedCaseDetailsState({required this.caseEntity, required this.lawyer, required this.comment});
}

class UpdateCaseState extends CaseState {
  final Case caseEntity;

  const UpdateCaseState({required this.caseEntity});
}

class CreateCommentState extends CaseState {
  final Comment comment;

  CreateCommentState({required this.comment});
}

class FinishCaseState extends CaseState {
  final Case caseEntity; 

  FinishCaseState({required this.caseEntity});
}

class ErrorCaseState extends CaseState {
  final String message;

  const ErrorCaseState({required this.message});
}