abstract class CaseEvent {
  const CaseEvent();
}

class GetCasesEvent extends CaseEvent {
  final String clientId; 

  const GetCasesEvent({required this.clientId});
}
