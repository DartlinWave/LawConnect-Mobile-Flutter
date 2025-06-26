import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lawconnect_mobile_flutter/features/cases/data/models/invitation_dto.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';

class InvitationService {

  // final String baseUrl = 'http://localhost:3000';
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<Invitation> fetchInvitationById(String id) async {
    final uri = Uri.parse('$baseUrl/invitations/$id');

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final invitation = jsonDecode(response.body);
      return InvitationDto.fromJson(invitation).toDomain();
    } else {
      throw Exception('Failed to fetch invitation: ${response.statusCode}');
    }
  }

  Future<List<Invitation>> fetchInvitationsByCaseId(String caseId) async {
    final uri = Uri.parse('$baseUrl/invitations')
        .replace(queryParameters: {'caseId': caseId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      List invitations = jsonDecode(response.body);

      if (invitations.isEmpty) {
        throw Exception('No invitations found for this case');
      }

      return invitations.map((invitation) => InvitationDto.fromJson(invitation).toDomain()).toList();
    } else {
      throw Exception('Failed to fetch invitations: ${response.statusCode} for case $caseId');
    }

  }
}