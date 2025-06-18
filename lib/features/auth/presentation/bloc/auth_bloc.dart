import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  
  AuthBloc() : super(InitialAuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());
      await Future.delayed(Duration(milliseconds: 1000));
      try {
        User user = await AuthService().login(event.username, event.password);
        emit(SuccessAuthState(user: user));
      } catch (e) {
        emit(FailureAuthState(message: e.toString()));
      }
    });
  }
  
}