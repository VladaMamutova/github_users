import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_users/bloc/user_search_cubit.dart';
import 'package:github_users/resources/repository.dart';
import 'package:github_users/ui/widgets/search_bar.dart';
import 'package:github_users/ui/widgets/user_list.dart';
import 'package:github_users/util/list_util.dart';

class SearchPage extends StatefulWidget {
  SearchPage();

  @override
  createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchName = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserSearchCubit>(
      create: (c) => UserSearchCubit(
        repository: context.read<Repository>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(64),
              child: AppBar(
                automaticallyImplyLeading: false,
                // remove the back button
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                // the values in the status bar are dark
                flexibleSpace: SearchBar(
                  onChanged: (v) {
                    setState(() => _searchName = v);
                    context.read<UserSearchCubit>().searchChanged(v);
                  },
                ),
              ),
            ),
            body: BlocBuilder<UserSearchCubit, UserSearchState>(
              builder: (c, state) {
                if (state.loading == true && nullOrEmpty(state.users)) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.users?.isNotEmpty == true) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Found ${state.totalResults} "
                        "user${state.totalResults == 1 ? "" : "s"}.",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: UserList(
                          users: state.users,
                          loading: state.loading && !nullOrEmpty(state.users),
                          onScrollToBottom: () {
                            context
                                .read<UserSearchCubit>()
                                .scrolledToTheBottom(_searchName);
                          },
                        ),
                      )
                    ],
                  );
                }

                if (state.error?.isNotEmpty == true) {
                  return Text(state.error ?? 'Unknown error happens');
                }

                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
