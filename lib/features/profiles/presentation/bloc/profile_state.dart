import 'package:lawconnect_mobile_flutter/features/auth/domain/entities/user.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/domain/entities/client.dart' as profile_client;

abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class LoadedClientProfileState extends ProfileState {
  final profile_client.Client client;
  final User user;

  LoadedClientProfileState({required this.client, required this.user});
}

class ErrorProfileState extends ProfileState {
  final String message;

  ErrorProfileState({required this.message});
}
