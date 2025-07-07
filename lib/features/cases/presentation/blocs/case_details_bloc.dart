import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/case_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/comment_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/invitation_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/models/comment_request_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_state.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/datasources/profile_service.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/lawyer.dart';

class CaseDetailsBloc extends Bloc<CaseDetailsEvent, CaseDetailsState> {
  CaseDetailsBloc() : super(InitialCaseDetailsState()) {
    on<GetCaseDetailsEvent>(_onGetCaseDetails);
    // on<CreateCommentEvent>(_onCreateComment);
    on<FinishCaseEvent>(_onFinishCase);
  }

  Future<void> _onGetCaseDetails(
    GetCaseDetailsEvent event,
    Emitter<CaseDetailsState> emit,
  ) async {
    emit(LoadingCaseDetailsState());
    try {
      final caseEntity = await CaseService().fetchCaseById(
        event.caseId,
        event.token,
      );

      // Si el caso está OPEN, no buscar invitaciones ni abogado
      if (caseEntity.status == CaseStatus.OPEN) {
        final clientProfile = await ProfileService().fetchClientByUserId(
          caseEntity.clientId,
          event.token,
        );
        final user = await AuthService().fetchUserById(clientProfile.userId);
        emit(
          LoadedCaseDetailsState(
            caseEntity: caseEntity,
            lawyer: null,
            client: clientProfile,
            user: user,
            comment: null,
          ),
        );
        return;
      }

      // Si el caso está en EVALUATION, obtener postulaciones
      if (caseEntity.status == CaseStatus.EVALUATION) {
        print('DEBUG: Entrando a EVALUATION para caseId: ' + caseEntity.id);
        final applications = await ApplicationService()
            .fetchApplicationsByCaseId(caseEntity.id, event.token);
        print('DEBUG: Applications fetched: ' + applications.toString());
        // Obtener perfiles de abogados postulantes
        final postulantLawyers = <Lawyer>[];
        for (final app in applications) {
          print(
            'DEBUG: Intentando obtener abogado para lawyerId: ' + app.lawyerId,
          );
          try {
            final lawyer = await ProfileService().fetchLawyerById(
              app.lawyerId,
              event.token,
            );
            print(
              'DEBUG: Lawyer fetched for application: ' + lawyer.toString(),
            );
            postulantLawyers.add(lawyer);
          } catch (e) {
            print('DEBUG: Error fetching lawyer for application: $e');
          }
        }
        print(
          'DEBUG: Postulant lawyers final list: ' + postulantLawyers.toString(),
        );
        final clientProfile = await ProfileService().fetchClientByUserId(
          caseEntity.clientId,
          event.token,
        );
        final user = await AuthService().fetchUserById(clientProfile.userId);
        emit(
          LoadedCaseDetailsState(
            caseEntity: caseEntity,
            lawyer: null, // No hay abogado asignado aún
            client: clientProfile,
            user: user,
            comment: null,
            postulantLawyers: postulantLawyers,
            applications: applications, // Incluir las aplicaciones en el estado
          ),
        );
        return;
      }

      final invitations = await InvitationService().fetchInvitationsByCaseId(
        event.caseId,
        event.token,
      );

      final acceptedInvitation = invitations.firstWhere(
        (inv) => inv.status == InvitationStatus.ACCEPTED,
        orElse: () => throw Exception('No lawyer was assigned to this case'),
      );

      final lawyer = await ProfileService().fetchLawyerById(
        acceptedInvitation.lawyerId,
        event.token,
      );

      final finalComment = await CommentService()
          .fetchFinalReviewCommentByCaseId(event.caseId, event.token);

      final clientProfile = await ProfileService().fetchClientByUserId(
        caseEntity.clientId,
        event.token,
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
      emit(ErrorCaseDetailsState(message: e.toString()));
    }
  }
  /*
  Future<void> _onCreateComment(
    CreateCommentEvent event,
    Emitter<CaseDetailsState> emit,
  ) async {
    emit(LoadingCaseDetailsState());

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
      emit(ErrorCaseDetailsState(message: e.toString()));
    }
  }
  */

  Future<void> _onFinishCase(
    FinishCaseEvent event,
    Emitter<CaseDetailsState> emit,
  ) async {
    emit(LoadingCaseDetailsState());

    try {
      await CommentService().createComment(
        CommentRequestDto(
          caseId: event.caseId,
          authorId: event.authorId,
          type: "FINAL_REVIEW",
          comment: event.comment,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      final closed = await CaseService().finishCaseStatus(
        event.caseId,
        "CLOSED",
      );

      emit(FinishCaseState(caseEntity: closed));
    } catch (e) {
      emit(ErrorCaseDetailsState(message: e.toString()));
    }
  }
}
