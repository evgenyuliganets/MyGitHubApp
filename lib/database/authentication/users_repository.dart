import 'package:my_github_app/database/authentication/model.dart';
import 'package:my_github_app/database/authentication/user_dao.dart';

class UsersRepository {
  final userDao = UserDao();

  Future<List<UserModel>> getAllUser({String  query}) => userDao.getUsers(query: query);

  Future insertUser(UserModel user) => userDao.createUser(user);

  Future updateUser(UserModel user) => userDao.updateUser(user);

  Future deleteTodoById(int id) => userDao.deleteUser(id);

  Future deleteAllUsers() => userDao.deleteAllUsers();
}