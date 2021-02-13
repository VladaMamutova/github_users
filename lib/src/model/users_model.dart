import 'package:github_users/src/model/user.dart';
import 'model_base.dart';

class UsersModel extends ModelBase {
  List<User> users;

  UsersModel({users});

  UsersModel.fromJson(List<dynamic> json) {
    users = List<User>();
    json.forEach((dynamic user) {
      users.add(User.fromJson(user));
    });
  }
}
