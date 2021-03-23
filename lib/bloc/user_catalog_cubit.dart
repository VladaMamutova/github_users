import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_users/model/user.dart';
import 'package:github_users/resources/repository.dart';
import 'package:github_users/util/log.dart';

part 'user_catalog_state.dart';

class UserCatalogCubit extends Cubit<UserCatalogState> {
  final String? fromLetter;
  final String? toLetter;
  final Repository? repository;

  UserCatalogCubit({
    this.fromLetter = 'a',
    this.toLetter = 'z',
    this.repository,
  }) : super(UserCatalogState.initial());

  onScreenOpened() async {
    _loadUsers();
  }

  onScrolledToBottom() async {
    _loadUsers();
  }

  //
  _loadUsers() async {
    try {
      emit(state.copyWith(
        loading: true,
      ));
      final users = await repository?.fetchUsers(state.users?.last.id ?? 0);
      emit(state.copyWith(
        loading: false,
        users: [
          ...state.users ?? [],
          ...users
                  ?.where((u) => u.name.toLowerCase().startsWith(_regexp()))
                  .toList() ??
              [],
        ],
      ));
    } catch (e, stack) {
      l('_loadUsers', e, stack);
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }

  _regexp() {
    final fromLower = fromLetter?.toLowerCase();
    final toLower = toLetter?.toLowerCase();
    return RegExp('^[$fromLower-$toLower]');
  }
}
