import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';

class InvitationDto {
  final int id;
  final String caseId;
  final String lawyerId;
  final InvitationStatus status;

  const InvitationDto({
    required this.id,
    required this.caseId,
    required this.lawyerId,
    required this.status,
  });

  factory InvitationDto.fromJson(Map<String, dynamic> json) {
    return InvitationDto(
      id: json['id'] as int,
      caseId: json['caseId'] as String,
      lawyerId: json['lawyerId'] as String,
      status: InvitationStatus.values.byName(json['status'] as String),
    );
  }

  Invitation toDomain() {
    return Invitation(
      id: id,
      caseId: caseId,
      lawyerId: lawyerId,
      status: status,
    );
  }
}
