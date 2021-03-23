import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_users/bloc/user_catalog_cubit.dart' as cubit;
import 'package:github_users/resources/repository.dart';
import 'package:github_users/util/list_util.dart';
import 'package:provider/provider.dart';

import 'user_list.dart';

class UserCatalog extends StatefulWidget {
  final String? fromLetter;
  final String? toLetter;

  UserCatalog({
    this.fromLetter,
    this.toLetter,
  });

  @override
  createState() => UserCatalogState();
}

class UserCatalogState extends State<UserCatalog>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<cubit.UserCatalogCubit>(
      create: (c) => cubit.UserCatalogCubit(
        fromLetter: widget.fromLetter,
        toLetter: widget.toLetter,
        repository: context.read<Repository>(),
      )..onScreenOpened(),
      child: BlocBuilder<cubit.UserCatalogCubit, cubit.UserCatalogState>(
        builder: (context, state) {
          if (state.loading == true && nullOrEmpty(state.users)) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.users?.isNotEmpty == true) {
            return UserList(
              users: state.users,
              loading: (state.loading ?? false) && !nullOrEmpty(state.users),
              onScrollToBottom:
                  context.read<cubit.UserCatalogCubit>().onScrolledToBottom,
            );
          }

          if (state.users?.isEmpty == true) {
            return Text('There are no users.');
          }

          if (state.error != null && state.error?.isNotEmpty == true) {
            return Text(state.error ?? '');
          }

          return Container();
        },
      ),
    );
  }
}
