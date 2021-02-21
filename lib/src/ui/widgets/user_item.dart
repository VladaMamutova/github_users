import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/src/model/user.dart';

class UserItem extends StatelessWidget {
  final User _user;
  final bool _isFirst;

  UserItem(this._user, this._isFirst);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(0, _isFirst ? 10 : 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.22,
                  maxHeight: MediaQuery.of(context).size.width * 0.22,
                ),
                child: Image.network(
                  _user.avatarUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text('${_user.followers} / ${_user.following}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
