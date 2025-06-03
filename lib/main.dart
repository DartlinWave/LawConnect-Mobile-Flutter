import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LawConnect Mobile',
      debugShowCheckedModeBanner: false,
      home: MainPage()
    );
  }
}
