import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/bloc/profile_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/bloc/profile_event.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/bloc/profile_state.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/views/profile_data_view.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_app_bar.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isProfileVisible = false;
  late final String userId;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is SuccessAuthState) {
      userId = authState.user.id;
      context.read<ProfileBloc>().add(GetClientProfileEvent(clientId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    final clientUsername = authState is SuccessAuthState
        ? authState.user.username
        : "Unknown User";

    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicAppBar(title: clientUsername),

                Center(
                  child: Column(
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is LoadingProfileState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is LoadedClientProfileState) {
                            return ProfileDataView(
                              client: state.client,
                              username: clientUsername,
                            );
                          } else if (state is ErrorProfileState) {
                            return Center(
                              child: Text("Error: ${state.message}"),
                            );
                          } else {
                            return Center(
                              child: Text("No profile data available."),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Visibilidad del Perfil',
                            style: TextStyle(fontSize: 16),
                          ),

                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isProfileVisible = !_isProfileVisible;
                              });
                            },
                            icon: Icon(
                              _isProfileVisible
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                          ),
                        ],
                      ),

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

                      SizedBox(height: 12),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
