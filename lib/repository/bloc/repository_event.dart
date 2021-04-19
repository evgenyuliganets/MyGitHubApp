part of 'repository_bloc.dart';

@immutable
abstract class RepositoryEvent {}
class GetRepo extends RepositoryEvent {
  final String userName;
  final String repoName;
  GetRepo(this.userName, this.repoName);
}
class GetRepos extends RepositoryEvent {
  final String repoName;
  GetRepos(this.repoName);
}
class GetUserRepos extends RepositoryEvent {
  final String userName;
  GetUserRepos(this.userName);
}