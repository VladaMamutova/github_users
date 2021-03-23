part of 'user_catalog_cubit.dart';

class UserCatalogState extends Equatable {
  final List<User>? users;
  final bool? loading;
  final String? error;

  UserCatalogState.initial()
      : users = null,
        error = null,
        loading = false;

  UserCatalogState({
    this.users,
    this.error,
    this.loading,
  });

  UserCatalogState copyWith({
    List<User>? users,
    String? error,
    bool? loading,
  }) {
    return UserCatalogState(
      users: users ?? this.users,
      error: error ?? this.error,
      loading: loading ?? this.loading,
    );
  }

  @override
  get props => [users, loading, error];
}
