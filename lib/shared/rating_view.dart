import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  
  final int rating;
  
  const RatingView({
    super.key, 
    required this.rating,
    
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //mainAxisSize: MainAxisSize.center,
      children: List.generate(rating, (index) {
        return Icon(
          Icons.star, 
          size: 14,
          color: Colors.amber);
      }),
    );
  }
}