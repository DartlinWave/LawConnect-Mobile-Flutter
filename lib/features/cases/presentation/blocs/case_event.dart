abstract class CaseEvent {
  const CaseEvent();
}

class GetCasesEvent extends CaseEvent {
  final String clientId; 
  final String token;

  const GetCasesEvent({required this.clientId, required this.token});
}

class CreateCaseEvent extends CaseEvent {
  final String clientId;
  final String title;
  final String description;
  final String token;

  const CreateCaseEvent({
    required this.clientId,
    required this.title,
    required this.description,
    required this.token,
  });
}

class GetCasesByStatusEvent extends CaseEvent {
  final String status;
  final String token;

  const GetCasesByStatusEvent({required this.status, required this.token});
}
