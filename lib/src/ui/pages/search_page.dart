import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/user_search_bloc.dart';
import 'package:github_users/src/model/user.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:github_users/src/ui/widgets/search_bar.dart';
import 'package:github_users/src/ui/widgets/user_item.dart';

class SearchPage extends StatefulWidget {
  final _users = <User>[];

  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: new AppBar(
          automaticallyImplyLeading: false, // remove the back button
          backgroundColor: Colors.white,
          brightness: Brightness.light, // the values in the status bar are dark
          flexibleSpace: Container(
            margin: const EdgeInsets.only(top: 48),
            child: SearchBar(),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: userSearchBloc.foundUsers,
          builder: (context, AsyncSnapshot<UsersModel> snapshot) {
            if (userSearchBloc.isFirstPage) {
              widget._users.clear();
            }

            if (snapshot.hasData) {
              return _buildContent(context, snapshot);
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

  Widget _buildContent(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData && snapshot.data.users.isNotEmpty) {
      widget._users.addAll(snapshot.data.users);
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16,),
          Text("Found ${userSearchBloc.totalResults} "
              "user${userSearchBloc.totalResults == 1 ? "" : "s"}.",
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 8,),
          Expanded(child: ListView.builder( // analog of RecyclerView in Android
              shrinkWrap: true,
              itemCount: userSearchBloc.hasReachedMax
                  ? widget._users.length
                  : widget._users.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < widget._users.length) {
                  return UserItem(widget._users[index], index == 0);
                } else {
                  userSearchBloc.searchMore();
                  return Center(child: CircularProgressIndicator());
                }
              }
          )
          ),
        ]
    );
  }
}
