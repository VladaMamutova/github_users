import 'package:github_users/src/bloc/bloc_base.dart';
import 'package:github_users/src/model/users_model.dart';
import 'package:rxdart/rxdart.dart';

class UserSearchBloc extends BlocBase<UsersModel> {
  String _searchName = "";
  int _page = 0;
  int _fetchedResults = 0;
  int _totalResults = 0;
  int _lastTime = DateTime.now().millisecondsSinceEpoch;
  bool _isSearching = false;

  Observable<UsersModel> get foundUsers => fetcher.stream;
  int get totalResults => _totalResults;
  bool get isFirstPage => _page == 1;
  bool get hasReachedMax => _fetchedResults == _totalResults;
  bool get isSearching => _isSearching;


  _resetSearchData() {
    fetcher.take(_fetchedResults);
    _searchName = "";
    _page = 0;
    _fetchedResults = 0;
    _totalResults = 0;
  }

  searchUsersByName(String name) async {
    if (name != _searchName) {
      _resetSearchData();
      _searchName = name;
    }

    if (_page == 0 || !hasReachedMax) {
      _isSearching = true;
      int startTime = DateTime.now().millisecondsSinceEpoch;
      UsersModel usersModel = await repository.searchUsersByName(_searchName, _page + 1);
      if (startTime > _lastTime) { // process only the last request
        _page++;
        _lastTime = startTime;
        _fetchedResults += usersModel.users.length;
        _totalResults = usersModel.totalResults;
        fetcher.sink.add(usersModel);
      }
      _isSearching = false;
    }
  }

  searchMore() {
    searchUsersByName(_searchName);
  }

  resetSearch() {
    _lastTime = DateTime.now().millisecondsSinceEpoch;
    _resetSearchData();
  }

  notifyLoading() {
    if (!_isSearching) {
      _isSearching = true;
      fetcher.add(null);
    }
  }

  notifyStopLoading() {
    if (_isSearching) {
      _isSearching = false;
      fetcher.add(null);
    }
  }
}

final userSearchBloc = UserSearchBloc();
