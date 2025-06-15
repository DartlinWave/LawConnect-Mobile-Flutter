import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/data/repositories/lawyer_repository.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_event.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_state.dart';


class LawyerBloc extends Bloc<LawyerEvent, LawyerState>
{
  final LawyerRepository _lawyerRepository = LawyerRepository();

  LawyerBloc() : super(InitialLawyerState()) {
    on<GetAllLawyersEvent>((event, emit) async {
      try {
        final lawyers = await _lawyerRepository.fetchAll();
        debugPrint('LawyerBloc: Fetched ${lawyers} lawyers');
        emit(LoadedLawyerState(lawyers));
      } catch (e) {
        // Handle error appropriately, e.g., emit an error state
        print('Error fetching lawyers: $e');
      }
    });
  }
}