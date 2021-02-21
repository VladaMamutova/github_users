import 'package:github_users/src/bloc/bloc_base.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:rxdart/rxdart.dart';

class UserListBloc extends BlocBase<UsersModel> {
  int _startId = 0; // '_' for private, int = 2^63
  bool _hasReachedMax = false;
  List<User> _unfilteredUsers = List<User>();

  Observable<UsersModel> get allUsers => fetcher.stream;
  bool get hasReachedMax => _hasReachedMax;

  fetchUsers() async {
    UsersModel usersModel = await repository.fetchUsers(_startId);
    if (_startId != usersModel.lastId) { // process only a new batch of users
      _startId = usersModel.lastId;
      fetcher.sink.add(usersModel);
    }

    if (usersModel.users.isEmpty) {
      _hasReachedMax = true;
    }
  }

  List<User> getFromUnfiltered(Function(User) filter) {
    List<User> users = List<User>();
    _unfilteredUsers = _unfilteredUsers.where((user) {
      if (!filter(user)) {
        return true;
      } else {
        users.add(user);
        return false;
      }
    }).toList();
    return users;
  }

  Observable<UsersModel> filterUsers(Function(User) filter) {
    return allUsers.map((model) =>
        UsersModel(model.users.where((user) {
          if (filter(user)) {
            return true;
          } else {
            _unfilteredUsers.add(user);
            return false;
          }
        }).toList()));
  }
}

final userListBloc = UserListBloc();
