import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class BasicAppBar extends StatelessWidget {
  final String title;

  const BasicAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, 10, 4, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorPalette.blackColor, width: 1),
        ),
        color: ColorPalette.whiteColor,
      ),
    
      child: Text(
        title,
        textAlign: TextAlign.start,
        
        style: TextStyle(
          fontSize: 16,
          color: ColorPalette.blackColor
        ),
      ),
    );
  }
}