import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_github_app/repository/data_repository/data_repository.dart';
import 'package:my_github_app/repository/models/model.dart';

part 'repository_event.dart';
part 'repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final RepoDataRepository _profileRepo;
  RepositoryBloc(this._profileRepo) : super(RepositoryInitial());

  @override
  Stream<RepositoryState> mapEventToState(
    RepositoryEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is GetRepo) {
      try {
        yield (RepositoryLoading());
        final repo = await _profileRepo.fetchRepo(event.userName,event.repoName);
        yield (RepositoryLoaded(repo));
      }  on RepoNotFoundException {
        yield (RepositoryError('This Repo was Not Found!'));
      } on TimeoutException {
        yield (RepositoryError("You have reached limit of query's! Wait at least a minute to continue."));}
    }
    else if (event is GetRepos) {
      try {
        yield (RepositoriesLoading());
        final repos = await _profileRepo.fetchRepos(event.repoName);
        yield (RepositoriesLoaded(repos));
      }on RepoNotFoundException {
        yield (RepositoriesError('This Repos were Not Found!'));
      } on TimeoutException {
        yield (RepositoriesError("You have reached limit of query's! Wait at least a minute to continue."));}
    }
    else if (event is GetUserRepos) {
      try {
        yield (RepositoriesLoading());
        final repos = await _profileRepo.fetchUserRepos(event.userName);
        yield (RepositoriesLoaded(repos));
      }on RepoNotFoundException {
        yield (RepositoriesError('This Repos were Not Found!'));
      } on TimeoutException {
        yield (RepositoriesError("You have reached limit of query's! Wait at least a minute to continue."));}
    }
  }
}
