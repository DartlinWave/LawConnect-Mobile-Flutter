import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/case_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';

class CaseBloc extends Bloc<CaseEvent, CaseState> {
  CaseBloc() : super(InitialCaseState()) {
    on<GetCasesEvent>(_onGetCases);
    on<CreateCaseEvent>(_onCreateCase);
    on<GetCasesByStatusEvent>(_onGetCasesByStatus);
  }

  Future<void> _onGetCases(GetCasesEvent event, Emitter<CaseState> emit) async {
    emit(LoadingCaseState());
    try {
      final cases = await CaseService().fetchCasesByClient(
        event.clientId,
        event.token,
      );
      emit(LoadedCasesState(cases: cases));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onCreateCase(
    CreateCaseEvent event,
    Emitter<CaseState> emit,
  ) async {
    emit(LoadingCaseState());
    try {
      await CaseService().createCase(
        clientId: event.clientId,
        title: event.title,
        description: event.description,
        token: event.token,
      );
      // Refresca la lista de casos después de crear uno nuevo
      final cases = await CaseService().fetchCasesByClient(
        event.clientId,
        event.token,
      );
      emit(LoadedCasesState(cases: cases));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }

  Future<void> _onGetCasesByStatus(
    GetCasesByStatusEvent event,
    Emitter<CaseState> emit,
  ) async {
    emit(LoadingCaseState());
    try {
      final cases = await CaseService().fetchCasesByStatus(
        status: event.status,
        token: event.token,
      );
      emit(LoadedCasesState(cases: cases));
    } catch (e) {
      emit(ErrorCaseState(message: e.toString()));
    }
  }
}
