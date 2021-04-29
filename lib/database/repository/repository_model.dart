class RepositoryModel {
   int id;
   String name;
   String description;
   String createdAt;
   String updatedAt;
   String language;
   String owner;
   int watchersCount;
   String defaultBranch;
  RepositoryModel({this.id, this.name, this.description,this.createdAt,this.owner,this.watchersCount,this.updatedAt,this.language,this.defaultBranch,});
  factory RepositoryModel.fromDatabaseJson(Map<String, dynamic> data) => RepositoryModel(
    id: data['id'],
    name: data['name'],
    description: data['description'] ,
    createdAt: data['createdAt'],
    updatedAt: data['updatedAt'],
    language: data['language'],
    owner: data['owner'],
    watchersCount: data['watchersCount'],
    defaultBranch: data['defaultBranch'],
  );
  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "name": this.name,
    "description": this.description ,
    "createdAt": this.createdAt ,
    "updatedAt": this.updatedAt ,
    "language": this.language ,
    "owner": this.owner ,
    "watchersCount": this.watchersCount ,
    "defaultBranch": this.defaultBranch ,
  };
}