import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/data/datasources/case_service.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';

class CaseBloc extends Bloc<CaseEvent, CaseState> {
  CaseBloc() : super(InitialCaseState()) {
    on<GetCasesEvent>(_onGetCases);
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
}
