abstract class ProfileEvent {
  const ProfileEvent();
}

class GetClientProfileEvent extends ProfileEvent {
  final String userId;
  final String token;

  const GetClientProfileEvent({required this.userId, required this.token});
}
