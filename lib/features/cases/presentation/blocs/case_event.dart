abstract class CaseEvent {
  const CaseEvent();
}

class GetCasesEvent extends CaseEvent {
  final String clientId; 

  const GetCasesEvent({required this.clientId});
}

class GetCaseDetailsEvent extends CaseEvent {
  final String caseId;

  const GetCaseDetailsEvent({required this.caseId});
}

class CreateCommentEvent extends CaseEvent {
  final String caseId;
  final String authorId;
  final String type;
  final String comment;

  const CreateCommentEvent({required this.caseId, required this.authorId, required this.type, required this.comment});
}

class UpdateCaseStatusEvent extends CaseEvent {
  final String caseId;
  final String status;

  const UpdateCaseStatusEvent({required this.caseId, required this.status});
}

class FinishCaseEvent extends CaseEvent {
  final String caseId;
  final String status;
  final String comment;

  const FinishCaseEvent({required this.caseId, required this.status, required this.comment});
}
