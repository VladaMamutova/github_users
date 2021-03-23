import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_users/model/user.dart';
import 'package:github_users/resources/repository.dart';
import 'package:github_users/util/log.dart';

part 'user_search_state.dart';

/// I have removed the logic with handling a few requests at a time
/// and handling only the latest one. Just to make refactoring easier.
/// You can add it in the future back.
/// Right now it's simply blocking any requests made during the web request
/// in a progress
class UserSearchCubit extends Cubit<UserSearchState> {
  final Repository? repository;

  UserSearchCubit({this.repository}) : super(UserSearchState.initial());

  int _page = 0;

  searchChanged(String name) {
    _page = 0;
    emit(state.copyWith(
      users: [],
    ));

    _searchByName(name);
  }

  scrolledToTheBottom(String name)  {
    _searchByName(name);
  }

  //
  _searchByName(String name) async {
    // skip search if we are making a web request right now
    if (state.loading) {
      return;
    }

    try {
      emit(state.copyWith(
        loading: true,
      ));
      final response = await repository?.searchUsersByName(
        name,
        _page + 1,
      );
      emit(state.copyWith(
        loading: false,
        users: [...state.users ?? [], ...response?.items ?? []],
        totalResults: response?.totalCount,
      ));
      _page++;
    } catch (e, stack) {
      l('_searchByName', e, stack);
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }
}
