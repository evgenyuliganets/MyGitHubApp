import 'package:my_github_app/database/profile/profiles_dao.dart';
import 'package:my_github_app/database/profile/profiles_model.dart';

class ProfilesRepository {
  final profileDao = ProfileDao();

  Future<List<ProfileModel>> getAllUser({String  query}) => profileDao.getUsers(query: query);

  Future insertUser(ProfileModel user) => profileDao.createProfile(user);

  Future updateUser(ProfileModel user) => profileDao.updateUser(user);

  Future deleteUserById(int id) => profileDao.deleteUser(id);

  Future deleteAllUsers() => profileDao.deleteAllUsers();
}