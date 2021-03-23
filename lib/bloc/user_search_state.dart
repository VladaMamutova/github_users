part of 'user_search_cubit.dart';

class UserSearchState extends Equatable {
  final List<User>? users;
  final int? lastId;
  final int? totalResults;
  final bool loading;
  final String? error;

  UserSearchState.initial()
      : users = null,
        lastId = 0,
        totalResults = 0,
        loading = false,
        error = null;

  UserSearchState({
    this.users,
    this.lastId,
    this.totalResults,
    this.loading = false,
    this.error,
  });

  UserSearchState copyWith({
    List<User>? users,
    int? lastId,
    int? totalResults,
    bool? loading,
    String? error,
  }) {
    return UserSearchState(
      users: users ?? this.users,
      lastId: lastId ?? this.lastId,
      totalResults: totalResults ?? this.totalResults,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  get props => [
        users,
        lastId,
        totalResults,
        loading,
        error,
      ];
}
