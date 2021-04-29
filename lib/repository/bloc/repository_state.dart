part of 'repository_bloc.dart';

@immutable
abstract class RepositoryState {
  const RepositoryState();
}

class RepositoryInitial extends RepositoryState {
  const RepositoryInitial();
}

class RepositoryLoading extends RepositoryState {
  const RepositoryLoading();
}

class RepositoryLoaded extends RepositoryState {
  final Repository repository;
  final String message;
  const RepositoryLoaded(this.repository,{this.message});
}

class RepositoryError extends RepositoryState {
  final String error;
  const RepositoryError(this.error);
}
class RepositoriesLoading extends RepositoryState {
  const RepositoriesLoading();
}

class RepositoriesError extends RepositoryState {
  final String error;
  const RepositoriesError(this.error);
}

class RepositoriesLoaded extends RepositoryState {
  final List<Repository> repository;
  final String message;
  const RepositoriesLoaded(this.repository, {this.message});
}

class UserRepositoriesLoading extends RepositoryState {
  const UserRepositoriesLoading();
}

class UserRepositoriesError extends RepositoryState {
  final String error;
  const UserRepositoriesError(this.error);
}

class UserRepositoriesLoaded extends RepositoryState {
  final List<Repository> repository;
  final String message;
  const UserRepositoriesLoaded(this.repository,{this.message});
}