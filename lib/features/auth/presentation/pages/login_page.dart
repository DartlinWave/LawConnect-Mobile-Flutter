
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/app/presentation/pages/main_page.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => {
        if (state is SuccessAuthState)
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            ),
          }
        else if (state is FailureAuthState)
          {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message))),
          },
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is LoadingAuthState;

          return Scaffold(
            backgroundColor: ColorPalette.whiteColor,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: isLoading,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Image.asset(
                          "assets/images/logo-lawconnect.png",
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),

                        SizedBox(height: 24),
                        
                        TextField(
                          cursorColor: ColorPalette.primaryColor,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person),
                            hintText: "Username",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 2,
                                color: ColorPalette.primaryColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        TextField(
                          cursorColor: ColorPalette.primaryColor,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                              icon: Icon(
                                _isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 2,
                                color: ColorPalette.primaryColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          obscureText: !_isVisible,
                        ),

                        SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/path-to-forgot-password');
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: ColorPalette.openColor,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        SizedBox(
                          child: BasicButton(
                            text: "Sign In",
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            },
                            width: 275,
                            height: 40,
                            backgroundColor: ColorPalette.mainButtonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 90,
                        height: 90,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}