import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:github/github.dart' as git;
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


      if (event is GetUser) {           //GetSingleUser or ProfileFull or DatabaseUser
        try {
          yield (ProfileLoading());
          final profile = await _profileRepo.fetchUser(event.userName).timeout(Duration(seconds: 2));
          yield (ProfileLoaded(profile:profile));
        }

        on TimeoutException {
          yield (ProfileError("No Internet Connection"));
          try {
            yield (ProfileLoading());
            final profile = await _profileRepo.fetchUserFromDataBase(event.userName);
            yield (ProfileLoaded(profile: profile,message: "User was loaded from database"));
          }
          on UserNotFoundException{
            yield (ProfileError('This User was not found in the database!'));
          }
        }

        on MyTimeoutException{
          yield (ProfileError("You have reached limit of query's! Wait at least a minute to continue."));
          try {
            yield (ProfileLoading());
            final profile = await _profileRepo.fetchUserFromDataBase(event.userName);
            yield (ProfileLoaded(profile: profile,message: "User was loaded from Database"));
          }
          on UserNotFoundException{
            yield (ProfileError('This User was not found in the database!'));}
        }

        on UserNotFoundException {
        yield (ProfileError("User was not Found!"));
        try {
          yield (ProfileLoading());
          final profile = await _profileRepo.fetchUserFromDataBase(event.userName);
          yield (ProfileLoaded(profile: profile,message: "User was loaded from Database"));
        }
        on UserNotFoundException{
          yield (ProfileError('This User was not found in the database!'));}}
      }


      else if (event is GetUsers) { //GetSearchUsers or DatabaseUsers
        try {
          yield (ProfilesLoading());
          final profile = await _profileRepo.fetchUsers(event.userName).timeout(
              Duration(seconds: 3));
          yield (ProfilesLoaded(profile: profile));
        }

        on TimeoutException {
          yield (ProfilesError("You have reached limit of query's! Wait at least a minute to continue."));
          try {
            yield (ProfilesLoading());
            final profile = await _profileRepo.fetchUsersFromDataBase(event.userName);
            yield (ProfilesLoaded(profile: profile,
                message: "Users have been loaded from the database"));
          }
          on UserNotFoundException {
            yield (ProfilesError(
                'Not a single User was found in the database!'));
          }
        }

        on MyTimeoutException{
          yield (ProfilesError("No Internet Connection"));
          try {
            yield (ProfilesLoading());
            final profile = await _profileRepo.fetchUsersFromDataBase(event.userName);
            yield (ProfilesLoaded(profile: profile,message: "User was loaded from Database"));
          }
          on UserNotFoundException{
            yield (ProfilesError('This User was not found in the database!'));}
        }

        on UserNotFoundException {
          yield (ProfilesError('Users was Not Found!'));
          try {
            yield (ProfilesLoading());
            final profile = await _profileRepo.fetchUsersFromDataBase(event.userName);
            yield (ProfilesLoaded(profile: profile,
                message: "Users have been loaded from the database"));
          }
          on UserNotFoundException {
            yield (ProfilesError(
                'Not a single User was found in the database!'));
          }
        }
      }
  }
}

