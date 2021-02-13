import 'package:github_users/src/model/users_model.dart';
import 'package:github_users/src/resources/github_api_provider.dart';

class Repository {
  final gitHubApiProvider = GitHubApiProvider();

  Future<UsersModel> fetchAllUsers() => gitHubApiProvider.fetchUsers();
}
