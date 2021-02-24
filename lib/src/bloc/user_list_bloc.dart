import 'package:github_users/src/bloc/bloc_base.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserListBloc extends BlocBase<UsersModel> {
  bool _allLoaded = false;

  Observable<UsersModel> get users => fetcher.stream;
  bool get allLoaded => _allLoaded;

  setLoaded(bool allLoaded) {
    _allLoaded = allLoaded;
  }

  loadUsers();
}
