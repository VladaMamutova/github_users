import 'dart:convert';
import 'package:github_users/src/model/users_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GitHubApiProvider {
  static const URL = 'https://api.github.com';
  static const SUCCESS_CODE = 200;
  static const USERS_PER_PAGE = 10;

  // A Future is used to represent a potential value, or error,
  // that will be available at some time in the future (analog of Optional in Kotlin).
  Future<UsersModel> fetchUsers(int page, {int perPage = USERS_PER_PAGE}) async {
    var oauthString = env['GITHUB_CLIENT_ID']+ ':' + env['GITHUB_CLIENT_SECRET'];
    var oauthInBase64 = base64.encode(utf8.encode(oauthString));
    var headers = {'Authorization': 'Basic ' + oauthInBase64,
      'Accept': 'application/vnd.github.v3+json'};

    int startIndex = page * perPage;
    final response = await http.get(
        '$URL/users?per_page=$perPage&since=$startIndex', headers: headers);
    if (response.statusCode == SUCCESS_CODE) {
      final usersModel = UsersModel.fromJson(json.decode(response.body));
      for (var user in usersModel.users) {
        final userResponse = await http.get('$URL/users/${user.login}', headers: headers);
        if (userResponse.statusCode == SUCCESS_CODE) {
          final jsonBody = json.decode(userResponse.body);
          user.followers = jsonBody['followers'];
          user.following = jsonBody['following'];
        }
      }
      return usersModel;
    } else {
      throw Exception('Failed to load users (status code: ${response.statusCode}): '
          '${json.decode(response.body)['message']}');
    }
  }
}
