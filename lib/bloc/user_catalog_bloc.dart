import 'package:github_users/bloc/user_list_bloc.dart';
import 'package:github_users/model/user.dart';
import 'package:github_users/model/users_model.dart';
import 'package:rxdart/rxdart.dart';

class UserCatalogBloc extends UserListBloc {
  int _startId = 0; // '_' for private, int = 2^63
  List<User> _unfilteredUsers = List<User>();

  @override
  loadUsers() {
    fetchUsers();
  }

  fetchUsers() async {
    if (!allLoaded) {
      UsersModel usersModel = await repository.fetchUsers(_startId);
      if (_startId != usersModel.lastId) { // process only a new batch of users
        _startId = usersModel.lastId;
        fetcher.sink.add(usersModel);
      }

      if (usersModel.users.isEmpty) {
        setLoaded(true);
      }
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
    return users.map((model) =>
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
