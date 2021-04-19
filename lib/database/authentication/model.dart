class UserModel {
  int id;
  String username;
  String password;
  UserModel({this.id, this.username, this.password});
  factory UserModel.fromDatabaseJson(Map<String, dynamic> data) => UserModel(
    id: data['id'],
    username: data['username'],
    password: data['password'] ,
  );
  Map<String, dynamic> toDatabaseJson() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "id": this.id,
    "username": this.username,
    "password": this.password ,
  };
}