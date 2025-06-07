import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/profile/domain/entities/client.dart';
import 'package:lawconnect_mobile_flutter/features/profile/presentation/views/profile_data_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Client> _client = [
    Client(
      id: '1',
      name: 'Jane',
      lastName: 'Doe',
      dni: '12345678',
      username: 'janedoe12',
      image:
          'https://economia3.com/wp-content/uploads/2019/12/Natalia-Juarranz-EQUIPO-HUMANO-450x450.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                ProfileDataView(clients: _client),

                SizedBox(height: 24),


                
                SizedBox(height: 24),


                BasicButton(
                  text: 'Sign Out',
                  onPressed: () {
                    // Acción al presionar el botón
                  },
                  width: 214,
                  height: 61,
                  backgroundColor: ColorPalette.mainButtonColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
