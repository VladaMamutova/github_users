import 'dart:async';

import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  SearchBar({this.onChanged});

  @override
  createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: TextField(
        autofocus: true,
        style: TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: "Search Github user",
          prefixIcon: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff757575),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffE0E0E0),
              width: 1.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffE0E0E0),
              width: 1.0,
            ),
          ),
        ),
        onChanged: _onSearchChanged,
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
      _debounce?.cancel();
    }

    if (text.isNotEmpty) {
      _debounce = Timer(
        const Duration(milliseconds: 500),
        () => widget.onChanged?.call(text),
      );
    }
  }
}
