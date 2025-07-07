import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart' as profile_client;
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class ProfileDataView extends StatelessWidget {
  const ProfileDataView({super.key, required this.client, required this.username});
  
  final profile_client.Client client;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          CircleAvatar(
            radius: 90,
            backgroundImage: NetworkImage(client.image),
          ),

          SizedBox(height: 36),

          // Full Name

          Container(
            width: 275,
            height: 36,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: ColorPalette.mainButtonColor)
            ),
            child: Text(
              '${client.fullName.firstname} ${client.fullName.lastname}',
              style: TextStyle(
                color: ColorPalette.blackColor,
              ),
            ),
          ),

          SizedBox(height: 18),

          // Username

          Container(
            width: 275,
            height: 36,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: ColorPalette.mainButtonColor)
            ),
            child: Text(
              username,
              style: TextStyle(
                color: ColorPalette.blackColor,
              ),
            ),
          ),
         
        ],
      ),
    ); 
    
  }

}
  