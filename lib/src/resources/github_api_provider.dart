import 'dart:convert';
import 'package:github_users/src/model/users_model.dart';
import 'package:http/http.dart' as http;

class GitHubApiProvider {
  static const USERS_URL = 'https://api.github.com/users';
  static const SUCCESS_CODE = 200;

  // A Future is used to represent a potential value, or error,
  // that will be available at some time in the future.
  Future<UsersModel> fetchUsers() async {
    final response = await http.get(USERS_URL + "?per_page=10");
    if (response.statusCode == SUCCESS_CODE) {
      final usersModel = UsersModel.fromJson(json.decode(response.body));
      for (var user in usersModel.users) {
        final userResponse = await http.get(user.url);
        if (userResponse.statusCode == SUCCESS_CODE) {
          final jsonBody = json.decode(userResponse.body);
          user.followers = jsonBody['followers'];
          user.following = jsonBody['following'];
          print(user);
        }
      }
      return usersModel;
    } else {
      throw Exception('Failed to load users (status code: ${response.statusCode}): '
          '${json.decode(response.body)['message']}');
    }
  }
}
