import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/case_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/comment_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/invitation_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/datasources/profile_service.dart';

class CaseBloc extends Bloc<CaseEvent, CaseState> {
  CaseBloc() : super(InitialCaseState()) {
    on<GetCasesEvent>(_onGetCases);
    on<GetCaseDetailsEvent>(_onGetCaseDetails);
    on<CreateCommentEvent>(_onCreateComment);
    on<FinishCaseEvent>(_onFinishCase);
  }

  Future<void> _onGetCases(GetCasesEvent event, Emitter<CaseState> emit) async {
    emit(LoadingCaseState());
    try {
      final cases = await CaseService().fetchCasesByClient(event.clientId);
      emit(LoadedCasesState(cases: cases));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onGetCaseDetails(
    GetCaseDetailsEvent event,
    Emitter<CaseState> emit,
  ) async {
    emit(LoadingCaseState());
    try {
      final caseEntity = await CaseService().fetchCaseById(event.caseId);

      final invitations = await InvitationService().fetchInvitationsByCaseId(
        event.caseId,
      );

      final acceptedInvitation = invitations.firstWhere(
        (inv) => inv.status == InvitationStatus.ACCEPTED,
        orElse: () => throw Exception('No lawyer was assigned to this case'),
      );

      final lawyer = await ProfileService().fetchLawyerById(
        acceptedInvitation.lawyerId,
      );

      final finalComment = await CommentService()
          .fetchFinalReviewCommentByCaseId(event.caseId);

      final clientProfile = await ProfileService().fetchClientById(
        caseEntity.clientId,
      );

      final user = await AuthService().fetchUserById(clientProfile.userId);
      emit(
        LoadedCaseDetailsState(
          caseEntity: caseEntity,
          lawyer: lawyer,
          client: clientProfile,
          user: user,
          comment: finalComment,
        ),
      );
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onCreateComment(
    CreateCommentEvent event,
    Emitter<CaseState> emit,
  ) async {
    emit(LoadingCaseState());

    try {
      final comment = await CommentService().createComment(
        CommentRequestDto(
          caseId: event.caseId,
          authorId: event.authorId,
          type: event.type,
          comment: event.comment,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      emit(CreateCommentState(comment: comment));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onFinishCase(
    FinishCaseEvent event,
    Emitter<CaseState> emit,
  ) async {
    emit(LoadingCaseState());

    try {
      final closed = await CaseService().finishCaseStatus(
        event.caseId,
        event.status,
        event.comment,
      );

      emit(FinishCaseState(caseEntity: closed));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }
}
