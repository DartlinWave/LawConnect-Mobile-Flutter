abstract class LawyerEvent {
  const LawyerEvent();
}

class GetAllLawyersEvent extends LawyerEvent {
  final String token;

  const GetAllLawyersEvent({required this.token});
}
