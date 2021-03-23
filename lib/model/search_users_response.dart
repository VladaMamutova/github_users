import 'package:github_users/model/user.dart';

class SearchUserResponse {
  List<User> items;
  int totalCount;

  SearchUserResponse({
    this.items = const [],
    this.totalCount = 0,
  });

  factory SearchUserResponse.fromJson(dynamic json) {
    return SearchUserResponse()
      ..items =
          (json['items'] as List).map((item) => User.fromJson(item)).toList()
      ..totalCount = (json['total_count'] ?? 0) as int;
  }
}
