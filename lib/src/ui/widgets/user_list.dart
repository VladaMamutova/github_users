import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/user_list_bloc.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:github_users/src/ui/widgets/user_item.dart';

class UserList extends StatefulWidget {
  final Function(User) filter;
  final _users = <User>[];

  UserList(this.filter);

  @override
  State<StatefulWidget> createState() {
    return UserListState();
  }
}

class UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    // load users from an unfiltered list after switching tabs
    widget._users.addAll(userListBloc.getFromUnfiltered(widget.filter));
    if (widget._users.isEmpty) {
      userListBloc.fetchUsers();
    }

    return StreamBuilder(
        stream: userListBloc.filterUsers(widget.filter),
        builder: (context, AsyncSnapshot<UsersModel> snapshot) {
          if (snapshot.hasData || widget._users.isNotEmpty) {
            return _buildContent(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData && snapshot.data.users.isNotEmpty) {
      widget._users.addAll(snapshot.data.users);
    }

    return Container(
        child: ListView.builder( // analog of RecyclerView in Android
            itemCount: userListBloc.hasReachedMax
                ? widget._users.length
                : widget._users.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < widget._users.length) {
                return UserItem(widget._users[index], index == 0);
              } else {
                userListBloc.fetchUsers();
                return Center(child: CircularProgressIndicator());
              }
            }
        )
    );
  }
}
