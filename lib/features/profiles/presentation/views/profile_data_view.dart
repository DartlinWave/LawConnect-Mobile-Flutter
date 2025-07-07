import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart'
    as profile_client;
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class ProfileDataView extends StatelessWidget {
  const ProfileDataView({
    super.key,
    required this.client,
    required this.username,
  });

  final profile_client.Client client;
  final String username;

  @override
  Widget build(BuildContext context) {
    final hasImage = client.image.isNotEmpty;
    final initials =
        (client.fullName.firstname.isNotEmpty
            ? client.fullName.firstname[0]
            : '') +
        (client.fullName.lastname.isNotEmpty
            ? client.fullName.lastname[0]
            : '');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          CircleAvatar(
            radius: 50,
            backgroundColor: ColorPalette.primaryColor.withOpacity(0.1),
            backgroundImage: hasImage ? NetworkImage(client.image) : null,
            child: !hasImage
                ? Text(
                    initials.toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      color: ColorPalette.primaryColor,
                    ),
                  )
                : null,
          ),
          SizedBox(height: 24),
          Text(
            '${client.fullName.firstname} ${client.fullName.lastname}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorPalette.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '@$username',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  _ProfileInfoRow(
                    icon: Icons.badge,
                    label: 'DNI',
                    value: client.dni,
                  ),
                  Divider(),
                  _ProfileInfoRow(
                    icon: Icons.phone,
                    label: 'Teléfono',
                    value: client.contactInfo.phoneNumber,
                  ),
                  Divider(),
                  _ProfileInfoRow(
                    icon: Icons.home,
                    label: 'Dirección',
                    value: client.contactInfo.address,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ColorPalette.primaryColor),
        SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[900]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
