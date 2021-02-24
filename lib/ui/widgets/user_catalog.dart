import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/bloc/user_catalog_bloc.dart';
import 'package:github_users/model/user.dart';
import 'package:github_users/model/users_model.dart';
import 'package:github_users/ui/widgets/user_list.dart';

class UserCatalog extends UserList {
  final Function(User) filter;

  UserCatalog(UserCatalogBloc userCatalogBloc, this.filter) : super(userCatalogBloc);

  @override
  State<StatefulWidget> createState() {
    return UserCatalogState();
  }
}

class UserCatalogState extends State<UserCatalog> {
  @override
  Widget build(BuildContext context) {
    final userCatalogBloc = widget.userListBloc as UserCatalogBloc;

    // load users from an unfiltered list after switching tabs
    widget.addUsers(userCatalogBloc.getFromUnfiltered(widget.filter));
    if (widget.hasNoUsers) {
      userCatalogBloc.fetchUsers();
    }

    return StreamBuilder(
        stream: userCatalogBloc.filterUsers(widget.filter),
        builder: (context, AsyncSnapshot<UsersModel> snapshot) {
          if (snapshot.hasData || widget.hasUsers) {
            return widget.buildUserList(context, snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }
}
