abstract class ProfileEvent {
  const ProfileEvent();
}

class GetClientProfileEvent extends ProfileEvent {
  final String clientId;

  const GetClientProfileEvent({required this.clientId});
}