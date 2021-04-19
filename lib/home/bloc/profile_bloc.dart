import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository _profileRepo;
  ProfileBloc(this._profileRepo) : super(ProfilesInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    // TODO: implement mapEventToState
      if (event is GetUser) {
        try {
          yield (ProfileLoading());
          final profile = await _profileRepo.fetchUser(event.userName);
          yield (ProfileLoaded(profile));
        }  on UserNotFoundException {
        yield (ProfileError('This User was Not Found!'));
        } on TimeoutException {
        yield (ProfileError("You have reached limit of query's! Wait at least a minute to continue."));}
      }
      else if (event is GetUsers) {
        try {
          yield (ProfilesLoading());
          final profile = await _profileRepo.fetchUsers(event.userName);
          yield (ProfilesLoaded(profile));
        }on UserNotFoundException {
          yield (ProfilesError('This User was Not Found!'));
        } on TimeoutException {
          yield (ProfilesError("You have reached limit of query's! Wait at least a minute to continue."));}
      }

  }
}

