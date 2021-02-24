import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/user_search_bloc.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:github_users/src/ui/widgets/search_bar.dart';
import 'package:github_users/src/ui/widgets/user_list.dart';

class SearchPage extends UserList {
  SearchPage(UserSearchBloc userSearchBloc) : super(userSearchBloc);

  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final userSearchBloc = widget.userListBloc as UserSearchBloc;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: new AppBar(
          automaticallyImplyLeading: false, // remove the back button
          backgroundColor: Colors.white,
          brightness: Brightness.light, // the values in the status bar are dark
          flexibleSpace: SearchBar(userSearchBloc),
        ),
      ),
      body: StreamBuilder(
          stream: userSearchBloc.users,
          builder: (context, AsyncSnapshot<UsersModel> snapshot) {
            if (userSearchBloc.isFirstPage) {
              widget.clear();
            }

            if (snapshot.hasData) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 16,),
                    Text("Found ${userSearchBloc.totalResults} "
                        "user${userSearchBloc.totalResults == 1 ? "" : "s"}.",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: 8,),
                    Expanded(
                        child: widget.buildUserList(context, snapshot)
                    )
                  ]
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (userSearchBloc.isSearching) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          }
      ),
    );
  }
}
