class Repository {
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String language;
  final String owner;
  final int watchersCount;
  final String defaultBranch;


  Repository({this.name, this.description, this.createdAt, this.updatedAt, this.language, this.owner, this.watchersCount, this.defaultBranch});
}