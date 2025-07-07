import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/invitation.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/applicant.dart';

class InvitationDto {
  final String id;
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
      id: json['id'] as String,
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

class ApplicationDto {
  final int id;
  final String caseId;
  final String lawyerId;
  final String status;

  ApplicationDto({
    required this.id,
    required this.caseId,
    required this.lawyerId,
    required this.status,
  });

  factory ApplicationDto.fromJson(Map<String, dynamic> json) {
    print('ApplicationDto.fromJson input: ' + json.toString());
    return ApplicationDto(
      id: json['id'] as int,
      caseId: json['caseId'] as String,
      lawyerId: json['lawyerId'] as String,
      status: json['status'] as String,
    );
  }

  Application toDomain() {
    print(
      'ApplicationDto.toDomain: id=$id, caseId=$caseId, lawyerId=$lawyerId, status=$status',
    );
    return Application(
      id: id,
      caseId: caseId,
      lawyerId: lawyerId,
      status: status,
    );
  }
}
