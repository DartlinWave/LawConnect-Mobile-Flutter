import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/data/repositories/lawyer_repository.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_event.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_state.dart';

class LawyerBloc extends Bloc<LawyerEvent, LawyerState> {
  final LawyerRepository _lawyerRepository = LawyerRepository();

  LawyerBloc() : super(InitialLawyerState()) {
    on<GetAllLawyersEvent>((event, emit) async {
      // No emitir LoadingLawyerState si ya tenemos datos cargados (para evitar parpadeos y reconstrucciones)
      if (state is! LoadedLawyerState) {
        emit(LoadingLawyerState());
      }

      try {
        final lawyers = await _lawyerRepository.fetchAllFromAPI(event.token);
        debugPrint('LawyerBloc: Fetched ${lawyers.length} lawyers from API');
        emit(LoadedLawyerState(lawyers));
      } catch (e) {
        debugPrint('LawyerBloc: Error fetching lawyers from API: $e');
        // Si falla la API y aún no tenemos datos, intentar con datos mock como fallback
        if (state is! LoadedLawyerState) {
          try {
            final mockLawyers = await _lawyerRepository.fetchAll();
            debugPrint(
              'LawyerBloc: Using mock data as fallback: ${mockLawyers.length} lawyers',
            );
            emit(LoadedLawyerState(mockLawyers));
          } catch (mockError) {
            debugPrint('LawyerBloc: Error fetching mock lawyers: $mockError');
            emit(ErrorLawyerState('Failed to load lawyers: $e'));
          }
        } else {
          // Si ya teníamos datos, mantenemos el estado actual
          debugPrint('LawyerBloc: Keeping current data due to API error');
        }
      }
    });
  }
}
