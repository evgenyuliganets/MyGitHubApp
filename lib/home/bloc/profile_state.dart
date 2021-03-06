part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}
class ProfilesInitial extends ProfileState {
  const ProfilesInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final String message;
  const ProfileLoaded({this.profile,this.message});
}

class ProfileError extends ProfileState {
  final String error;
  const ProfileError(this.error);
}


class ProfilesLoading extends ProfileState {
  const ProfilesLoading();
}

class ProfilesError extends ProfileState {
  final String error;
  const ProfilesError(this.error);
}

class ProfilesLoaded extends ProfileState {
  final List<Profile> profile;
  final String message;
  const ProfilesLoaded({this.profile,this.message});
}
