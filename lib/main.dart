import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/login_page.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/main_page.dart';
import 'package:lawconnect_mobile_flutter/features/home/presentation/blocs/lawyer_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<LawyerBloc>(create: (context) => LawyerBloc()),        
      ],
      child: MaterialApp(      
        title: 'LawConnect Mobile',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        theme: ThemeData(
          fontFamily: 'PlusJakartaSans',
        ),
      ),
    );
  }
}
