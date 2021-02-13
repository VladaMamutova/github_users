import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/users_bloc.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';

class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserListState();
  }
}

class UserListState extends State<UserList>{
  @override
  Widget build(BuildContext context) {
    usersBloc.fetchUsers();
    return StreamBuilder(
        stream: usersBloc.allUsers,
        builder: (context, AsyncSnapshot<UsersModel> snapshot) {
      if (snapshot.hasData) {
        return buildContent(context, snapshot);
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      return Container(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(),),
      );
    });
  }

  Widget buildContent(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.users.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(snapshot.data.users[index]);
        },
      ),
    );
  }

  _buildItem(User user) {
    print(user);
    return ListTile(
       title: Text(user.login),
       subtitle: Text('${user.followers} / ${user.following}'),
       leading: CircleAvatar(
         child: Image.network(
           user.avatarUrl),
      ),
    );
  }
}
