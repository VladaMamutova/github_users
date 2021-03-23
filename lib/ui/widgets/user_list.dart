import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/model/user.dart';
import 'package:github_users/ui/widgets/user_item.dart';

class UserList extends StatelessWidget {
  final List<User>? users;
  final VoidCallback? onScrollToBottom;
  final bool loading;

  const UserList({
    Key? key,
    this.users,
    this.loading = false,
    this.onScrollToBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users == null) {
      return Container();
    }

    final usersCount = users?.length ?? 0;

    return Container(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          // atEdge returns when we scroll to some edge - top or bottom
          // we will take only the bottom one
          if (scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
            onScrollToBottom?.call();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: loading ? usersCount + 1 : usersCount,
          itemBuilder: (context, index) {
            if (index < usersCount) {
              return UserItem((users ?? [])[index], index == 0);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
