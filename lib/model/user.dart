class User {
  String login;
  String name;
  String avatarUrl;
  int followers;
  int following;

  User({this.login = '', this.name = '', this.avatarUrl = '',
    this.followers = 0, this.following = 0});  // {} - for named optional parameters

  @override
  String toString() {
    return 'User{login: $login, name: $name, avatarUrl: $avatarUrl, '
        'followers: $followers, following: $following}';
  }

  static bool filterFromAtoH(User user) {
    return user.name.startsWith(RegExp(r'[A-Ha-h]'));
  }

  static bool filterFromItoP(User user) {
    return user.name.startsWith(RegExp(r'[I-Pi-p]'));
  }

  static bool filterFromQtoZ(User user) {
    return user.name.startsWith(RegExp(r'[Q-Zq-z]'));
  }
}
