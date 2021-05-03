import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:github/github.dart' as git;
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

    if (event is GetRepo) {           //GetSingleRepo or UserRepo or DatabaseRepo
      try {
        yield (RepositoryLoading());
        final repo = await _profileRepo.fetchRepo(event.repoName,event.userName).timeout(Duration(seconds: 2));
        yield (RepositoryLoaded(repo));
      }

      on TimeoutException {
        yield (RepositoryError("No Internet Connection"));
        try {
          yield (RepositoryLoading());
          final repo = await _profileRepo.fetchRepoFromDataBase(event.repoName,event.userName);
          yield (RepositoryLoaded(repo,message: "Data was loaded from database"));
        }
        on RepoNotFoundException{
            yield (RepositoryError('This Repo was not found in the database!'));}

      }

      on MyTimeoutException{
        yield (RepositoryError("You have reached limit of query's! Wait at least a minute to continue."));
        try {
          yield (RepositoryLoading());
          final repo = await _profileRepo.fetchRepoFromDataBase(event.repoName,event.userName);
          yield (RepositoryLoaded(repo,message: "Data was loaded from Database"));
        }
        on RepoNotFoundException{
          yield (RepositoryError('This Repo was not found in the database!'));}
      }

      on RepoNotFoundException {
        yield (RepositoryError('This Repo was Not Found!'));
        try {
          yield (RepositoryLoading());
          final repo = await _profileRepo.fetchRepoFromDataBase(event.repoName,event.userName);
          yield (RepositoryLoaded(repo,message: "Data was loaded from database"));
        }on RepoNotFoundException{
          yield (RepositoryError('This Repo was not found in the database!'));}
      }
    }

    else if (event is GetRepos) {           //GetSearchRepos or DatabaseRepos
      try {
        yield (RepositoriesLoading());
        final repos = await _profileRepo.fetchRepos(event.repoName).timeout(Duration(seconds: 3));
        yield (RepositoriesLoaded(repos));
      }

      on TimeoutException {
        yield (RepositoriesError("You have reached limit of query's! Wait at least a minute to continue."));
        try {
          yield (RepositoriesLoading());
          final repos = await _profileRepo.fetchReposFromDataBase();
          yield (RepositoriesLoaded(repos,message: "All Repos have been loaded from the database"));
        }
        on RepoNotFoundException{
          yield (RepositoriesError('Not a single Repo was found in the database!'));
        }
      }

      on MyTimeoutException{
        yield (RepositoriesError("No Internet Connection"));
        try {
          yield (RepositoriesLoading());
          final repos = await _profileRepo.fetchReposFromDataBase();
          yield (RepositoriesLoaded(repos,message: "All Repos have been loaded from the database"));
        }
        on RepoNotFoundException{
          yield (RepositoriesError('Not a single Repo was found in the database!'));}
      }

      on RepoNotFoundException {
        yield (RepositoriesError('This Repos was Not Found!'));
      }
    }


    else if (event is GetUserRepos) {         //GetUserRepos or DatabaseUserRepos
      try {
        yield (UserRepositoriesLoading());
        final repos =   await _profileRepo.fetchUserRepos(event.userName).timeout(Duration(seconds: 2));
        yield (UserRepositoriesLoaded(repos));
      }

      on TimeoutException {
        try {
          yield (UserRepositoriesLoading());
          final repos = await _profileRepo.fetchUserReposFromDataBase(event.userName);
          yield (UserRepositoriesLoaded(repos,message: "User Repos have been loaded from the database"));
        }
        on RepoNotFoundException{
          yield (UserRepositoriesError('Not a single User Repo was found in the database!'));
        }
      }

      on MyTimeoutException{
        try {
          yield (UserRepositoriesLoading());
          final repos = await _profileRepo.fetchUserReposFromDataBase(event.userName);
          yield (UserRepositoriesLoaded(repos,message: "User Repos have been loaded from the database"));
        }
        on RepoNotFoundException{
          yield (UserRepositoriesError('Not a single Repo was found in the database!'));}
      }

      on RepoNotFoundException {
        yield (UserRepositoriesError('This User Repos were Not Found!'));
        try {
          yield (UserRepositoriesLoading());
          final repos = await _profileRepo.fetchUserReposFromDataBase(event.userName);
          yield (UserRepositoriesLoaded(repos,message: "User Repos have been loaded from the database"));
        }
        on RepoNotFoundException{
          yield (UserRepositoriesError('Not a single Repo was found in the database!'));}
      }
    }
  }
}
