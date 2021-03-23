import 'package:flutter/material.dart';
import 'package:github_users/ui/pages/search_page.dart';
import 'package:github_users/ui/widgets/search_card.dart';
import 'package:github_users/ui/widgets/user_catalog.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(169),
          child: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            // the values in the status bar are dark
            flexibleSpace: Container(
              margin: const EdgeInsets.only(
                left: 12,
                top: 40,
                right: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "GitHub Users",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SearchCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  TabBar(
                    indicatorWeight: 3,
                    labelColor: Color(0xff2D2727),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
            UserCatalog(
              fromLetter: 'a',
              toLetter: 'h',
            ),
            UserCatalog(
              fromLetter: 'i',
              toLetter: 'p',
            ),
            UserCatalog(
              fromLetter: 'q',
              toLetter: 'z',
            ),
          ],
        ),
      ),
    );
  }
}
