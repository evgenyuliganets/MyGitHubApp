import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository _profileRepo;
  ProfileBloc(this._profileRepo) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    // TODO: implement mapEventToState
    try {
      if (event is GetUser) {
        yield (ProfileLoading());
        final profile = await _profileRepo.fetchUser(event.userName);
        yield (ProfileLoaded(profile));
      }
    } on UserNotFoundException {
      yield (ProfileError('This User was Not Found!'));
    }
  }
}
