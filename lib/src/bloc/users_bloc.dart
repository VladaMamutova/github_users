import 'package:github_users/src/bloc/bloc_base.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:rxdart/rxdart.dart';

class UsersBloc extends BlocBase<UsersModel> {
  int _startId = 0; // '_' for private, int = 2^63
  bool _hasReachedMax = false;
  List<User> _unfilteredUsers = List<User>();

  Observable<UsersModel> get allUsers => fetcher.stream;
  bool get hasReachedMax => _hasReachedMax;

  fetchUsers() async {
    UsersModel usersModel = await repository.fetchUsers(_startId);
    if (usersModel.users.isNotEmpty) {
      if (_startId != usersModel.lastId) {
        _startId = usersModel.lastId;
        fetcher.sink.add(usersModel);
      }
    } else {
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

  Observable<UsersModel> gitFilteredUsers(Function(User) filter) {
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
  
  bool filterFromAtoH(User user) {
    return user.name.startsWith(RegExp(r'[A-Ha-h]'));
  }

  bool filterFromItoQ(User user) {
    return user.name.startsWith(RegExp(r'[I-Qi-q]'));
  }

  bool filterFromPtoZ(User user) {
    return user.name.startsWith(RegExp(r'[P-Zp-z]'));
  }
}

final usersBloc = UsersBloc();
