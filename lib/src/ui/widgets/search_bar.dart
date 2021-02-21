import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github_users/src/bloc/text_bloc.dart';
import 'package:github_users/src/bloc/user_search_bloc.dart';

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  final _searchTextBloc = TextBloc();
  Timer _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder(
          stream: _searchTextBloc.textStream,
          builder: (context, AsyncSnapshot<String> textStream) {
            return TextField(
              autofocus: true,
              style: TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: "Search Github user",
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xff757575),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE0E0E0), width: 1.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE0E0E0), width: 1.0),
                ),
              ),
              onChanged: _onSearchChanged,
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }

    _searchTextBloc.updateText(text);
    userSearchBloc.notifyLoading();
    if (text.isEmpty) {
      userSearchBloc.resetSearch();
      userSearchBloc.notifyStopLoading();
    } else {
      _debounce = Timer(const Duration(milliseconds: 500), () {
        userSearchBloc.searchUsersByName(text);
      });
    }
  }
}

