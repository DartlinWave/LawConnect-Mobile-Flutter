import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/case_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/comment_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/invitation_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/datasources/profile_service.dart';

class CaseBloc extends Bloc<CaseEvent, CaseState> {
  final CaseService _caseService;
  final CommentService _commentService;
  final ProfileService _profileService;
  final InvitationService _invitationService;

  CaseBloc({
    required CaseService caseService,
    required CommentService commentService,
    required ProfileService profileService,
    required InvitationService invitationService,
  }) : _caseService = caseService,
       _commentService = commentService,
       _profileService = profileService,
       _invitationService = invitationService,
       super(InitialCaseState()) {
    on<GetCasesEvent>(_onGetCases);
    on<GetCaseDetailsEvent>(_onGetCaseDetails);
    on<CreateCommentEvent>(_onCreateComment);
    on<FinishCaseEvent>(_onFinishCase);
  }

  Future<void> _onGetCases(GetCasesEvent event, Emitter<CaseState> emit) async {
    emit(LoadingCaseState());
    try {
      final cases = await _caseService.fetchCasesByClient(event.clientId);
      emit(LoadedCasesState(cases: cases));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onGetCaseDetails(GetCaseDetailsEvent event, Emitter<CaseState> emit) async {
    emit(LoadingCaseState());
    try {
      final caseEntity = await _caseService.fetchCaseById(event.caseId);
      
  final invitations = await _invitationService.fetchInvitationsByCaseId(event.caseId);

  final acceptedInvitation = invitations.firstWhere(
    (inv) => inv.status == InvitationStatus.ACCEPTED,
    orElse: () => throw Exception('No lawyer was assigned to this case'),
  );

      final lawyer = await _profileService.fetchLawyerById(acceptedInvitation.lawyerId);
      
      final comment = await _commentService.fetchCommentByCaseId(event.caseId);
      
      emit(LoadedCaseDetailsState(caseEntity: caseEntity, lawyer: lawyer, comment: comment));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onCreateComment(CreateCommentEvent event, Emitter<CaseState> emit) async {
    emit(LoadingCaseState());

    try {
      final comment = await _commentService.createComment(
        CommentRequestDto(
          caseId: event.caseId, 
          authorId: event.authorId, 
          type: event.type,
          comment: event.comment, 
          createdAt: DateTime.now().toIso8601String())
      );

      emit(CreateCommentState(comment: comment));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onFinishCase(FinishCaseEvent event, Emitter<CaseState> emit) async {
    emit(LoadingCaseState());

    try {
      final closed = await _caseService.finishCaseStatus(event.caseId, event.status, event.comment);

      emit(FinishCaseState(caseEntity: closed));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }
}
