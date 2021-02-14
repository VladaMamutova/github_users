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
      return Center(child: CircularProgressIndicator(),);
    });
  }

  Widget buildContent(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.users.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(snapshot.data.users[index], index == 0);
        },
      ),
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
