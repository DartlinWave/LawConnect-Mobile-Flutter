import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class BasicAppBar extends StatelessWidget {
  final String title;

  const BasicAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: ColorPalette.whiteColor,
      foregroundColor: ColorPalette.blackColor
    );
  }
}