import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class LawyerProfilePage extends StatefulWidget {
  final Map<String, dynamic>? lawyerData; // Datos del abogado
  final bool
  showActionButtons; // Para mostrar botones Decline/Match solo desde casos

  const LawyerProfilePage({
    super.key,
    this.lawyerData,
    this.showActionButtons = false, // Por defecto no muestra los botones
  });

  @override
  State<LawyerProfilePage> createState() => _LawyerProfilePageState();
}

class _LawyerProfilePageState extends State<LawyerProfilePage> {
  Map<String, dynamic>? _lawyer;
  final List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLawyerProfile();
  }

  Future<void> _fetchLawyerProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Si hay datos pasados desde la navegación, usarlos directamente
    if (widget.lawyerData != null) {
      setState(() {
        _lawyer = widget.lawyerData;
        _isLoading = false;
      });
    } else {
      // TODO: Fetch lawyer profile from backend if no data provided
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isLoading = false;
        // TODO: Replace with actual data from backend
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: ColorPalette.whiteColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
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

                const SizedBox(height: 24),

                // Lawyer profile image
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorPalette.lighterButtonColor,
                    image:
                        (_lawyer?['image'] != null ||
                            _lawyer?['imageUrl'] != null)
                        ? DecorationImage(
                            image: NetworkImage(
                              _lawyer?['image'] ?? _lawyer?['imageUrl'] ?? '',
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      (_lawyer?['image'] == null &&
                          _lawyer?['imageUrl'] == null)
                      ? Center(
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: ColorPalette.greyColor,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 24),

                // Lawyer name and rating row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _lawyer?['name'] ??
                                'Lawyer Name', // TODO: Get from backend
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.blackColor,
                            ),
                          ),
                          Text(
                            _lawyer?['specialty'] ??
                                'Specialty', // TODO: Get from backend
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorPalette.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rating stars
                    Row(
                      children: List.generate(
                        _lawyer?['rating'] ?? 0, // TODO: Get from backend
                        (index) =>
                            Icon(Icons.star, color: Colors.amber, size: 28),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  _lawyer?['description'] ??
                      'Lawyer description will be loaded from backend.', // TODO: Get from backend
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: ColorPalette.blackColor,
                  ),
                ),

                const SizedBox(height: 32),

                // Reviews section
                _reviews.isEmpty
                    ? _buildEmptyReviewsState()
                    : Row(
                        children: [
                          if (_reviews.isNotEmpty)
                            Expanded(child: _buildReviewCard(_reviews[0])),
                          if (_reviews.length > 1) ...[
                            const SizedBox(width: 12),
                            Expanded(child: _buildReviewCard(_reviews[1])),
                          ],
                        ],
                      ),

                const SizedBox(height: 40),

                // Action buttons - solo mostrar cuando showActionButtons es true (desde casos en EVALUATION)
                if (widget.showActionButtons)
                  Row(
                    children: [
                      Expanded(
                        child: BasicButton(
                          text: "Decline",
                          onPressed: () {
                            // TODO: Handle decline action
                            // TODO: Send decline to backend
                            // TODO: Navigate to next lawyer or back
                            _handleDecline();
                          },
                          width: double.infinity,
                          height: 48,
                          backgroundColor: ColorPalette.declineButtonColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BasicButton(
                          text: "Match",
                          onPressed: () {
                            // TODO: Handle match action
                            // TODO: Send match to backend
                            // TODO: Show match confirmation
                            // TODO: Navigate to chat or matches screen
                            _handleMatch();
                          },
                          width: double.infinity,
                          height: 48,
                          backgroundColor: ColorPalette.matchButtonColor,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyReviewsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text(
          'No reviews available yet',
          style: TextStyle(fontSize: 16, color: ColorPalette.greyColor),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.greyColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: review['userImageUrl'] != null
                    ? NetworkImage(review['userImageUrl'])
                    : null,
                backgroundColor: ColorPalette.lighterButtonColor,
                child: review['userImageUrl'] == null
                    ? Icon(Icons.person, color: ColorPalette.greyColor)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] ?? 'User', // TODO: Get from backend
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.blackColor,
                      ),
                    ),
                    Text(
                      review['userRole'] ??
                          'Customer', // TODO: Get from backend
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] ??
                'Review comment will be loaded from backend.', // TODO: Get from backend
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: ColorPalette.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  void _handleDecline() {
    // TODO: Implement decline logic
    print('Lawyer declined');
    // TODO: Send decline to backend
    // TODO: Update UI or navigate to next lawyer
    // TODO: Show feedback message
  }

  void _handleMatch() {
    // TODO: Implement match logic
    print('Lawyer matched');
    // TODO: Send match to backend
    // TODO: Show match confirmation dialog
    // TODO: Navigate to chat or matches screen
    // TODO: Update user's matches list
  }
}

// EJEMPLO DE USO:
//
// Para mostrar la página sin botones de acción (desde Home o Lawyers):
// Navigator.push(context, MaterialPageRoute(
//   builder: (context) => LawyerProfilePage(
//     lawyerData: lawyerData,
//     showActionButtons: false, // Por defecto
//   ),
// ));
//
// Para mostrar la página con botones Decline/Match (desde casos en EVALUATION):
// Navigator.push(context, MaterialPageRoute(
//   builder: (context) => LawyerProfilePage(
//     lawyerData: lawyerData,
//     showActionButtons: true, // Muestra botones para casos en evaluación
//   ),
// ));
