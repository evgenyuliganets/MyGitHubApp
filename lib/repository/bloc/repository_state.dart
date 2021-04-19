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
  const RepositoryLoaded(this.repository);
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
  const RepositoriesLoaded(this.repository);
}