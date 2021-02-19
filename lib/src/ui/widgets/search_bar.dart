import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
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
      ),
    );
  }
}
