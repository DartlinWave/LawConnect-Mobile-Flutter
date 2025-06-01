import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/custom_widgets/basic_button.dart';
import 'package:lawconnect_mobile_flutter/theme/color_palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                // TODO: do onPressed
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