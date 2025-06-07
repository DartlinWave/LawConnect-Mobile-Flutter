import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/profile/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';

class ProfileDataView extends StatelessWidget {
  const ProfileDataView({super.key, required this.clients});
  
  final List<Client> clients;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          // Profile title
          BasicAppBar(title: clients[0].username),

          SizedBox(height: 100),
          CircleAvatar(
            radius: 90,
            backgroundImage: NetworkImage(clients[0].image),
          ),

          SizedBox(height: 36),

          // Full Name

          Container(
            width: 275,
            height: 36,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: ColorPalette.greyColor,
              border: Border.all(color: ColorPalette.mainButtonColor)
            ),
            child: Text(
              clients[0].name + clients[0].lastName,
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
              color: ColorPalette.greyColor,
              border: Border.all(color: ColorPalette.mainButtonColor)
            ),
            child: Text(
              clients[0].username,
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
  