import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/main_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is SuccessAuthState) {
          // User is authenticated, show main page
          return const MainPage();
        } else {
          // User is not authenticated, show login page
          return const LoginPage();
        }
      },
    );
  }
}
