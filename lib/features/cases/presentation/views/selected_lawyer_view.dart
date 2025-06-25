import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_state.dart';

class SelectedLawyerView extends StatelessWidget {
  const SelectedLawyerView({
    super.key,
    required this.onFullProfile,
    required this.onContact,
  });

  final VoidCallback onFullProfile;
  final VoidCallback onContact;

  // func to format the lawyer's specialties
  String formatSpecialties(String specialty) {
    final formatSpecialty = specialty.replaceAll("_LAW", "").toLowerCase();
    return formatSpecialty[0].toUpperCase() + formatSpecialty.substring(1);
  }

  // TODO: implement the option in case there is no selected lawyer and just applicants

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseBloc, CaseState>
    (builder: (context, state) {
      if (state is LoadedCaseDetailsState) {
        final lawyer = state.lawyer;

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected Lawyer",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ColorPalette.blackColor,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  // Image of lawyer
                  Container(
                    width: 69,
                    height: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(image: NetworkImage(lawyer.image)),
                    ),
                  ),
        
                  SizedBox(width: 12),
        
                  // Name, specialty and rating with stars
        
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${lawyer.fullName.firstname} ${lawyer.fullName.lastname}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          // to get all the specialties of the lawyer
                          lawyer.specialties.map((s) => formatSpecialties(s)).join(", "),
                          style: TextStyle(color: ColorPalette.blackColor),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < lawyer.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Color.fromRGBO(247, 193, 16, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  // Buttons for client to check on the lawyer
                  Column(
                    children: [
                      TextButton(
                        onPressed: onFullProfile,
                        style: TextButton.styleFrom(
                          backgroundColor: ColorPalette.lighterButtonColor,
                          foregroundColor: ColorPalette.blackColor,
                        ),
                        child: Text("Full Profile"),
                      ),
        
                      SizedBox(height: 6),
        
                      TextButton(
                        onPressed: onContact,
                        style: TextButton.styleFrom(
                          backgroundColor: ColorPalette.lighterButtonColor,
                          foregroundColor: ColorPalette.blackColor,
                        ),
                        child: Text("Contact"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18),
              Divider(color: ColorPalette.blackColor, height: 1),
            ],
        
          ),
        );
      }
      return const Text("Error loading selected lawyer");
    }
    );
  }
}