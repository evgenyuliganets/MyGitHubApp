part of 'repository_bloc.dart';

@immutable
abstract class RepositoryEvent {}
class GetRepo extends RepositoryEvent {
  final String repoName;
  final String userName;
  GetRepo(this.repoName, this.userName);
}
class GetRepos extends RepositoryEvent {
  final String repoName;
  GetRepos(this.repoName);
}
class GetUserRepos extends RepositoryEvent {
  final String userName;
  GetUserRepos(this.userName);
}