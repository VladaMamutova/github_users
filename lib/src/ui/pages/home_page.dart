import 'package:flutter/material.dart';
import 'package:github_users/src/ui/pages/search_page.dart';
import 'package:github_users/src/ui/widgets/search_card.dart';
import 'package:github_users/src/ui/widgets/user_list.dart';
import 'package:github_users/src/bloc/users_bloc.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(153),
          child: new AppBar(
            backgroundColor: Colors.white,
            flexibleSpace:
            new Container(
              margin: const EdgeInsets.only(left: 12, top: 28, right: 12),
              child: Column(
                children: [
                  Text(
                    "GitHub Users",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 12),
                  SearchCard(onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },),
                  SizedBox(height: 12),
                  TabBar(
                    indicatorWeight: 3,
                    labelColor: Color(0xff2D2727),
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                    tabs: [
                      Tab(text: "A - H"),
                      Tab(text: "I - P"),
                      Tab(text: "Q - Z")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
            children: [
              UserList(usersBloc.filterFromAtoH),
              UserList(usersBloc.filterFromItoP),
              UserList(usersBloc.filterFromQtoZ),
            ]),
      ),
    );
  }
}
