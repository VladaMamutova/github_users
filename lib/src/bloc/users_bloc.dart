import 'package:github_users/src/bloc/bloc_base.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:rxdart/rxdart.dart';

class UsersBloc extends BlocBase<UsersModel> {
  Observable<UsersModel> get allUsers => fetcher.stream;

  fetchUsers() async {
    UsersModel usersModel = await repository.fetchAllUsers();
    fetcher.sink.add(usersModel);
  }
}

final usersBloc = UsersBloc();
