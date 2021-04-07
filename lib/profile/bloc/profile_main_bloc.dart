import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_main_event.dart';
part 'profile_main_state.dart';

class ProfileMainBloc extends Bloc<ProfileMainEvent, ProfileMainState> {
  ProfileMainBloc() : super(ProfileMainInitial());

  @override
  Stream<ProfileMainState> mapEventToState(
    ProfileMainEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
