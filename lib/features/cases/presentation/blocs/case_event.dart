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
  final String comment;

  const CreateCommentEvent({required this.caseId, required this.comment});
}

class FinishCaseEvent extends CaseEvent {
  final String caseId;
  final String comment;

  const FinishCaseEvent({required this.caseId, required this.comment});
}
