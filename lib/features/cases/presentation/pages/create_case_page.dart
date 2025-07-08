import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_event.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({super.key});

  @override
  State<CreateCasePage> createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedSpecialty = 'None';
  final List<String> _specialtyOptions = [
    'None',
    'Specialty',
    'Qualifications',
    'Experience',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User header with underline
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User 1', // TODO: Get user name from backend
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: ColorPalette.greyColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Create Case title
              Center(
                child: Text(
                  'Create Case',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.blackColor,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title field
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.greyColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: ColorPalette.greyColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description field
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorPalette.greyColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: ColorPalette.greyColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Specialty dropdown
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorPalette.lighterButtonColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSpecialty,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorPalette.blackColor,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorPalette.blackColor,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSpecialty = newValue!;
                      });
                    },
                    items: _specialtyOptions.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const Spacer(),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: BasicButton(
                      text: "Cancel",
                      onPressed: () {
                        // TODO: Handle cancel action
                        Navigator.pop(context);
                      },
                      width: double.infinity,
                      height: 48,
                      backgroundColor: ColorPalette.declineButtonColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BasicButton(
                      text: "Create",
                      onPressed: () {
                        // TODO: Handle create case action
                        // TODO: Validate form fields
                        // TODO: Send data to backend
                        // TODO: Show success/error message
                        // TODO: Navigate back or to case details
                        _handleCreateCase();
                      },
                      width: double.infinity,
                      height: 48,
                      backgroundColor: ColorPalette.matchButtonColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateCase() {
    // Add form validation
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get client information from auth state
    final authState = context.read<AuthBloc>().state;
    if (authState is SuccessAuthState) {
      final clientId = authState.user.id;
      final token = authState.user.token;

      // Create case using CaseBloc
      context.read<CaseBloc>().add(
        CreateCaseEvent(
          clientId: clientId,
          title: _titleController.text,
          description: _descriptionController.text,
          token: token,
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Case created successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to cases page
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
