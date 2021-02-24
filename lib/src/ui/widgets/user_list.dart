import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/user_list_bloc.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:github_users/src/ui/widgets/user_item.dart';

abstract class UserList extends StatefulWidget {
  final List<User> _users = <User>[];
  final UserListBloc _userListBloc;

  UserListBloc get userListBloc => _userListBloc;
  bool get hasUsers => _users.isNotEmpty;
  bool get hasNoUsers => _users.isEmpty;

  UserList(this._userListBloc);

  addUsers(Iterable<User> users) {
    _users.addAll(users);
  }

  clear() {
    _users.clear();
  }

  Widget buildUserList(BuildContext context, AsyncSnapshot<UsersModel> snapshot) {
    if (snapshot.hasData && snapshot.data.users.isNotEmpty) {
      addUsers(snapshot.data.users);
    }

    return Container(
        child: ListView.builder( // analog of RecyclerView in Android
            itemCount: _userListBloc.allLoaded ? _users.length : _users.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < _users.length) {
                return UserItem(_users[index], index == 0);
              } else {
                _userListBloc.loadUsers();
                return Center(child: CircularProgressIndicator());
              }
            }
        )
    );
  }
}
