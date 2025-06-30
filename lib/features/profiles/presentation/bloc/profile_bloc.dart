import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/datasources/profile_service.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/bloc/profile_event.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(InitialProfileState()) {
    on<GetClientProfileEvent>(_onGetClientProfile);
  }

  Future<void> _onGetClientProfile(GetClientProfileEvent event, Emitter<ProfileState> emit) async {
    emit(LoadingProfileState());

    try {
      final client = await ProfileService().fetchClientById(event.clientId);
      final user = await AuthService().fetchUserById(client.userId);
      emit(LoadedClientProfileState(client: client, user: user));
    } catch (e) {
      emit(ErrorProfileState(message: e.toString()));
    }
  }
}