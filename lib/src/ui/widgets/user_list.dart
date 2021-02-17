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
  final _users = <User>[];
  int page = 0;
  bool hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    usersBloc.fetchUsers(page);
    return StreamBuilder(
        stream: usersBloc.allUsers,
        builder: (context, AsyncSnapshot<UsersModel> snapshot) {
      if (snapshot.hasData) {
        return _buildContent(context, snapshot);
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return Center(child: CircularProgressIndicator(),);
      }
    });
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data.users.isEmpty) {
      hasReachedMax = true;
    } else {
      _users.addAll(snapshot.data.users);
    }

    return Container(
        child: ListView.builder( // analog of RecyclerView in Android
            itemCount: hasReachedMax ? _users.length : _users.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < _users.length) {
                return _buildItem(_users[index], index == 0);
              } else {
                page++;
                usersBloc.fetchUsers(page);
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
                    Text(user.login,
                      style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26
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
