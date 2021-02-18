import 'package:github_users/src/model/user.dart';
import 'model_base.dart';

class UsersModel extends ModelBase {
  List<User> users;
  int lastId = 0;

  UsersModel(List<User> _users) {
    users = _users;
  }

  UsersModel.fromJson(List<dynamic> json) {
    users = List<User>();
    json.forEach((dynamic userJson) {
      var user = User(login: userJson['login'] as String,
          avatarUrl: userJson['avatar_url'] as String);
      users.add(user);
    });
  }
}
