abstract class CaseDetailsEvent {
  const CaseDetailsEvent();
}

class GetCaseDetailsEvent extends CaseDetailsEvent {
  final String caseId;

  const GetCaseDetailsEvent({required this.caseId});
}

class CreateCommentEvent extends CaseDetailsEvent {
  final String caseId;
  final String authorId;
  final String type;
  final String comment;

  const CreateCommentEvent({required this.caseId, required this.authorId, required this.type, required this.comment});
}

class UpdateCaseStatusEvent extends CaseDetailsEvent {
  final String caseId;
  final String status;

  const UpdateCaseStatusEvent({required this.caseId, required this.status});
}

class FinishCaseEvent extends CaseDetailsEvent {
  final String caseId;
  final String authorId;
  final String comment;

  const FinishCaseEvent({required this.caseId, required this.authorId, required this.comment});
}