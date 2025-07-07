import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoCs
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_bloc.dart';

// Pages
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/login_page.dart';
// Si quieres usar el login de auth, cambia la línea de arriba por:
// import 'package:lawconnect_mobile_flutter/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<CaseBloc>(create: (_) => CaseBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<LawyerBloc>(create: (_) => LawyerBloc()),
      ],
      child: MaterialApp(
        title: 'LawConnect Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'PlusJakartaSans'),
        home: const LoginPage(),
      ),
    );
  }
}
