
import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/shared/rating_view.dart';

class CardDoctorView extends StatelessWidget {
  //
  final String name;
  final String specialty;
  final String rating;
  final String imageUrl;

  const CardDoctorView({
    super.key, 
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return 
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(
                  color: Colors.grey, // Set your border color
                  width: 1,           // Set your border width
                ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: 120,          
            child: Column(          
              children: [
                SizedBox(height: 15),
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 30, // 120 de diámetro como antes
                  backgroundColor: Colors.grey[200],
                ), 
                SizedBox(height: 10),         
                Text(
                  name, 
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                RatingView(rating:  int.parse(rating)),            
                SizedBox(height: 10),
                 Text(specialty, style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.normal,
                    )), 
                SizedBox(height: 10),       
                ],
                  ),
          ),
        );                   
  }
}