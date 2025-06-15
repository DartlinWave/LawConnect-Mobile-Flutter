import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/main_page.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // THIS IS JUST TO REVIEW THE USE OF BUTTONS
      // TODO: add home functionality
      backgroundColor: ColorPalette.whiteColor,
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BasicButton(
              text: "Sign Up",
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ));
              },
              width: 275,
              height: 40,
              backgroundColor: ColorPalette.mainButtonColor,
            ),
            SizedBox(height: 8,),
            BasicButton(
              text: "Match", 
              onPressed: () {
                // TODO: do onPressed
              }, 
              width: 175, 
              height: 40, 
              backgroundColor: ColorPalette.matchButtonColor,
            ),
            SizedBox(height: 8,),
            BasicButton(
              text: "Decline", 
              onPressed: () {
                // TODO: do onPressed
              }, 
              width: 175, 
              height: 40, 
              backgroundColor: ColorPalette.declineButtonColor,
            ),
          ],
        ),
        
      ),
    );
  }
}