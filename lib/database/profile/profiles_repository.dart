import 'package:my_github_app/database/profile/profiles_dao.dart';
import 'package:my_github_app/database/profile/profiles_model.dart';

class ProfilesRepository {
  final profileDao = ProfileDao();

  Future<List<ProfileModel>> getAllUserProfile({String  query}) => profileDao.getUsersProfiles(query: query);

  Future insertUserProfile(ProfileModel profile) => profileDao.createProfile(profile);

  Future updateUserProfile(ProfileModel profile) => profileDao.updateUserProfile(profile);

  Future deleteUserProfileByLogin(String login) => profileDao.deleteUserProfile(login);

  Future deleteAllUsersProfile() => profileDao.deleteAllUsersProfiles();

  Future getUserProfile(String login) => profileDao.getUserProfile(login);

  Future checkIfExist(String login) => profileDao.checkIfExist(login);
}