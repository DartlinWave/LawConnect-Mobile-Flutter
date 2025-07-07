import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart' as profile_client;
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

abstract class CaseDetailsState {
  const CaseDetailsState();
}

class InitialCaseDetailsState extends CaseDetailsState {}

class LoadingCaseDetailsState extends CaseDetailsState {}

class LoadedCaseDetailsState extends CaseDetailsState {
  final Case caseEntity;
  final Lawyer lawyer;
  final profile_client.Client client;
  final User user;
  final Comment? comment;

  const LoadedCaseDetailsState({required this.caseEntity, required this.lawyer, required this.client, required this.user, required this.comment});
}

class UpdateCaseState extends CaseDetailsState {
  final Case caseEntity;

  const UpdateCaseState({required this.caseEntity});
}

class CreateCommentState extends CaseDetailsState {
  final Comment comment;

  CreateCommentState({required this.comment});
}

class FinishCaseState extends CaseDetailsState {
  final Case caseEntity; 

  FinishCaseState({required this.caseEntity});
}

class ErrorCaseDetailsState extends CaseDetailsState {
  final String message;

  const ErrorCaseDetailsState({required this.message});
}