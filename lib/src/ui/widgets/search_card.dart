import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final TapCallback onTap;

  SearchCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text("Search user",
                    style: TextStyle(fontSize: 18, color: Color(0xff757575),),
                  ),
                ),
                Icon(Icons.search, color: Color(0xff757575),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef TapCallback = void Function();
