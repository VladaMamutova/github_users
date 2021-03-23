import 'package:github_users/model/search_users_response.dart';
import 'package:github_users/model/user.dart';
import 'package:github_users/resources/github_api_provider.dart';

class Repository {
  final _gitHubApiProvider = GitHubApiProvider();

  Future<List<User>> fetchUsers(int startId) =>
      _gitHubApiProvider.fetchUsers(startId);

  Future<SearchUserResponse> searchUsersByName(String name, int page) =>
      _gitHubApiProvider.searchUsersByName(name, page);
}
