import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/users_bloc.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';

class UserList extends StatefulWidget {
  final Function(User) filter;
  final _users = <User>[];

  UserList(this.filter);

  @override
  State<StatefulWidget> createState() {
    return UserListState();
  }
}

class UserListState extends State<UserList>{
  @override
  Widget build(BuildContext context) {
    // load users from an unfiltered list after switching tabs
    widget._users.addAll(usersBloc.getFromUnfiltered(widget.filter));
    if (widget._users.isEmpty) {
      usersBloc.fetchUsers();
    }

    return StreamBuilder(
        stream: usersBloc.gitFilteredUsers(widget.filter),
        builder: (context, AsyncSnapshot<UsersModel> snapshot) {
          if (snapshot.hasData || widget._users.isNotEmpty) {
            return _buildContent(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        });
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData && !usersBloc.hasReachedMax) {
      widget._users.addAll(snapshot.data.users);
    }

    return Container(
        child: ListView.builder( // analog of RecyclerView in Android
            itemCount: usersBloc.hasReachedMax ? widget._users.length : widget._users.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < widget._users.length) {
                if (widget._users[index] == null) {
                  print("null on index = $index");
                }
                return _buildItem(widget._users[index], index == 0);
              } else {
                usersBloc.fetchUsers();
                return Center(child: CircularProgressIndicator());
              }
            }
            )
    );
  }

  _buildItem(User user, bool isFirst) {
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(0, isFirst ? 10 : 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.2,
                  maxHeight: MediaQuery.of(context).size.width * 0.2,
                ),
                child:  Image.network(
                  user.avatarUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text('${user.followers} / ${user.following}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
