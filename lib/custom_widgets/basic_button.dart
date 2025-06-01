import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/theme/color_palette.dart';

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;

  const BasicButton(
    {super.key, 
    required this.text, 
    required this.onPressed,
    required this.width,
    required this.height,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,

      child: FilledButton(
        onPressed: onPressed, 
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            color: ColorPalette.whiteColor,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}