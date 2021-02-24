import 'package:github_users/bloc/searcher.dart';
import 'package:github_users/bloc/user_list_bloc.dart';
import 'package:github_users/model/users_model.dart';

class UserSearchBloc extends UserListBloc implements Searcher {
  String _searchName = "";
  int _page = 0;
  int _fetchedResults = 0;
  int _totalResults = 0;
  int _lastTime = DateTime.now().millisecondsSinceEpoch;
  bool _isSearching = false;

  int get totalResults => _totalResults;
  bool get isFirstPage => _page == 1;
  bool get isSearching => _isSearching;

  _resetSearchOptions() {
    fetcher.take(_fetchedResults);
    _searchName = "";
    _page = 0;
    _fetchedResults = 0;
    _totalResults = 0;
  }

  @override
  loadUsers() {
    searchByName(_searchName);
  }


  @override
  searchByName(String name) async {
    if (name != _searchName) {
      _resetSearchOptions();
      _searchName = name;
    }

    if (_page == 0 || !allLoaded) {
      _isSearching = true;
      int startTime = DateTime.now().millisecondsSinceEpoch;
      UsersModel usersModel = await repository.searchUsersByName(_searchName, _page + 1);
      if (startTime > _lastTime) { // process only the last request
        _page++;
        _lastTime = startTime;
        _fetchedResults += usersModel.users.length;
        _totalResults = usersModel.totalResults;
        setLoaded(_fetchedResults == _totalResults);
        fetcher.sink.add(usersModel);
      }
      _isSearching = false;
    }
  }

  @override
  resetSearch() {
    _lastTime = DateTime.now().millisecondsSinceEpoch;
    _resetSearchOptions();
  }

  @override
  notifyStartSearching() {
    if (!_isSearching) {
      _isSearching = true;
      fetcher.add(null);
    }
  }

  @override
  notifyStopSearching() {
    if (_isSearching) {
      _isSearching = false;
      fetcher.add(null);
    }
  }
}
