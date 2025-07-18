import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/case_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/comment_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/applicant.dart';
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
        print('DEBUG: Entrando a EVALUATION para caseId: ${caseEntity.id}');
        final applications = await ApplicationService()
            .fetchApplicationsByCaseId(caseEntity.id, event.token);
        print('DEBUG: Applications fetched: $applications');
        // Obtener perfiles de abogados postulantes
        final postulantLawyers = <Lawyer>[];
        for (final app in applications) {
          print(
            'DEBUG: Intentando obtener abogado para lawyerId: ${app.lawyerId}',
          );
          try {
            final lawyer = await ProfileService().fetchLawyerById(
              app.lawyerId,
              event.token,
            );
            print('DEBUG: Lawyer fetched for application: $lawyer');
            postulantLawyers.add(lawyer);
          } catch (e) {
            print('DEBUG: Error fetching lawyer for application: $e');
          }
        }
        print('DEBUG: Postulant lawyers final list: $postulantLawyers');
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

      // Si el caso está ACCEPTED o CLOSED, obtener el abogado asignado
      if (caseEntity.status == CaseStatus.ACCEPTED ||
          caseEntity.status == CaseStatus.CLOSED) {
        print(
          'DEBUG: Entrando a ACCEPTED/CLOSED para caseId: ${caseEntity.id}',
        );
        try {
          final applications = await ApplicationService()
              .fetchApplicationsByCaseId(caseEntity.id, event.token);
          print('DEBUG: Applications fetched for ACCEPTED case: $applications');

          // Buscar la aplicación aceptada
          final acceptedApplication = applications.firstWhere(
            (app) => app.status == 'ACCEPTED',
            orElse: () =>
                throw Exception('No accepted application found for this case'),
          );

          final lawyer = await ProfileService().fetchLawyerById(
            acceptedApplication.lawyerId,
            event.token,
          );
          print('DEBUG: Assigned lawyer fetched: $lawyer');

          final clientProfile = await ProfileService().fetchClientByUserId(
            caseEntity.clientId,
            event.token,
          );
          final user = await AuthService().fetchUserById(clientProfile.userId);

          // Intentar obtener comentario final si el caso está cerrado
          Comment? finalComment;
          if (caseEntity.status == CaseStatus.CLOSED) {
            try {
              finalComment = await CommentService()
                  .fetchFinalReviewCommentByCaseId(event.caseId, event.token);
            } catch (e) {
              print('DEBUG: No final comment found: $e');
              finalComment = null;
            }
          }

          emit(
            LoadedCaseDetailsState(
              caseEntity: caseEntity,
              lawyer: lawyer,
              client: clientProfile,
              user: user,
              comment: finalComment,
              postulantLawyers: [],
              applications: applications,
            ),
          );
          return;
        } catch (e) {
          print('DEBUG: Error handling ACCEPTED/CLOSED case: $e');
          emit(
            ErrorCaseDetailsState(message: 'Error loading case details: $e'),
          );
          return;
        }
      }
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
    // Keep track of the current state to access token for subsequent calls
    final currentState = state;

    // Extract token from the current state if it's a loaded state
    if (currentState is LoadedCaseDetailsState) {
      final loadedState = currentState;

      // Update UI to loading state while keeping important data
      emit(LoadingCaseDetailsState());

      try {
        // First save the final review comment using the new endpoint for final comments
        print('Creating final comment for case ${event.caseId}');
        bool finalCommentSuccess = await CommentService().createFinalComment(
          event.caseId,
          event.authorId,
          event.comment,
          token: event.token, // Pass the token
        );
        print('Final comment created successfully: $finalCommentSuccess');

        // Call the new endpoint to close the case
        print('Closing case ${event.caseId} with client ${event.authorId}');
        print('Using token: ${event.token}');

        // Pass the token to the closeCase method
        bool closeSuccess = await CaseService().closeCase(
          event.caseId,
          event.authorId,
          token: event.token, // Pass the token
        );

        print('Case closed successfully: $closeSuccess');

        // Only update the state if the API call was successful
        if (closeSuccess) {
          // Create a closed case entity from the current one
          final closedCase = Case(
            id: loadedState.caseEntity.id,
            clientId: loadedState.caseEntity.clientId,
            title: loadedState.caseEntity.title,
            description: loadedState.caseEntity.description,
            status: CaseStatus.CLOSED, // Update status to CLOSED
            image: loadedState.caseEntity.image,
            createdAt: loadedState.caseEntity.createdAt,
            updatedAt: DateTime.now(),
            applicationsCount: loadedState.caseEntity.applicationsCount,
          );

          // Update the state to finished
          emit(FinishCaseState(caseEntity: closedCase));
        } else {
          emit(
            ErrorCaseDetailsState(
              message: 'Failed to close case. Backend did not confirm closure.',
            ),
          );
        }
      } catch (e) {
        print('Error closing case: $e');
        emit(ErrorCaseDetailsState(message: 'Error closing case: $e'));
      }
    } else {
      // If we're not in a loaded state, we can't proceed
      emit(
        ErrorCaseDetailsState(
          message: 'Cannot close case: no case details available',
        ),
      );
    }
  }
}
