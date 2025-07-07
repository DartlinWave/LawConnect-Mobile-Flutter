import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/auth/data/datasources/auth_service.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/data/datasources/profile_service.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // 1. Crear usuario
      final userResp = await AuthService().signUp(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      final userId = userResp['id'] as String;
      // 2. Crear perfil
      await ProfileService().createClientProfile(
        userId: userId,
        firstname: _firstnameController.text.trim(),
        lastname: _lastnameController.text.trim(),
        dni: _dniController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
      _showSnackBar('¡Registro exitoso! Ahora puedes iniciar sesión.');
      Navigator.pop(context); // Volver al login
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', error: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: ColorPalette.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: ColorPalette.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Usuario'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dniController,
                  decoration: const InputDecoration(labelText: 'DNI'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : BasicButton(
                        text: 'Registrarse',
                        onPressed: _handleSignUp,
                        width: 200,
                        height: 45,
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
