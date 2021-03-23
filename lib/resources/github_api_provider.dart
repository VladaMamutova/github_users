import 'dart:convert';
import 'package:github_users/model/search_users_response.dart';
import 'package:github_users/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final clientId = env['GITHUB_CLIENT_ID'];
final clientSecret = env['GITHUB_CLIENT_SECRET'];

class GitHubApiProvider {
  static const url = 'https://api.github.com';
  static const successCode = 200;
  static const usersPerPage = 30;
  static const searchUsersPerPage = 10;

  // A Future is used to represent a potential value, or error,
  // that will be available at some time in the future (analog of Optional in Kotlin).
  Future<List<User>> fetchUsers(
    int startId, {
    int perPage = usersPerPage,
  }) async {
    final response = await http.get(
      Uri.parse('$url/users?per_page=$perPage&since=$startId'),
      headers: _headers(),
    );

    if (response.statusCode == successCode) {
      final users = (json.decode(response.body) as List)
          .map((json) => User.fromJson(json))
          .toList();
      for (var user in users) {
        final userResponse = await http.get(
          Uri.parse('$url/users/${user.login}'),
          headers: _headers(),
        );

        if (userResponse.statusCode == successCode) {
          final jsonBody = json.decode(userResponse.body);
          user.name = jsonBody['name'] ?? user.login;
          user.followers = jsonBody['followers'];
          user.following = jsonBody['following'];
        }
      }

      return users;
    }

    throw Exception(
      'Failed to load users (status code: ${response.statusCode}): '
      '${json.decode(response.body)['message']}',
    );
  }

  Future<SearchUserResponse> searchUsersByName(
    String name,
    int page, {
    int perPage = searchUsersPerPage,
  }) async {
    final response = await http.get(
      Uri.parse('$url/search/users?q=$name&per_page=$perPage&page=$page'),
      headers: _headers(),
    );

    if (response.statusCode == successCode) {
      final searchResponse = SearchUserResponse.fromJson(
        json.decode(response.body),
      );

      for (var user in searchResponse.items) {
        final userResponse = await http.get(
          Uri.parse('$url/users/${user.login}'),
          headers: _headers(),
        );

        if (userResponse.statusCode == successCode) {
          final jsonBody = json.decode(userResponse.body);
          user.name = jsonBody['name'] ?? user.login;
          user.followers = jsonBody['followers'];
          user.following = jsonBody['following'];
        }
      }

      return searchResponse;
    }
    throw Exception(
      'Failed to search users (status code: ${response.statusCode}): '
      '${json.decode(response.body)['message']}',
    );
  }

  Map<String, String> _headers() {
    var oauthString = '$clientId:$clientSecret';
    var oauthInBase64 = base64.encode(utf8.encode(oauthString));
    return {
      'Authorization': 'Basic ' + oauthInBase64,
      'Accept': 'application/vnd.github.v3+json'
    };
  }
}
