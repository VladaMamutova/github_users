import 'package:github_users/src/model/users_model.dart';
import 'package:github_users/src/resources/github_api_provider.dart';

class Repository {
  final _gitHubApiProvider = GitHubApiProvider();

  Future<UsersModel> fetchUsers(int startId) =>
      _gitHubApiProvider.fetchUsers(startId);

  Future<UsersModel> searchUsersByName(String name, int page) =>
      _gitHubApiProvider.searchUsersByName(name, page);
}
