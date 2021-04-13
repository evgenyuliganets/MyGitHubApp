import 'package:my_github_app/database/model.dart';
import 'package:my_github_app/database/profile_dao.dart';

class UsersRepository {
  final userDao = ProfileDao();

  Future<List<UserModel>> getAllUser({String  query}) => userDao.getUsers(query: query);

  Future insertUser(UserModel user) => userDao.createTodo(user);

  Future updateUser(UserModel user) => userDao.updateUser(user);

  Future deleteTodoById(int id) => userDao.deleteUser(id);

  //We are not going to use this in the demo
  Future deleteAllUsers() => userDao.deleteAllUsers();
}