import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/ui/widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 48, bottom: 12),
              child: SearchBar(),
          ),

        ],
    ),
    );
  }
}
