class User {
  String login;
  String avatarUrl;
  int followers;
  int following;
  String url;

  User({login, avatarUrl, followers, following, url});  // {} - for named optional parameters

  @override
  String toString() {
    return 'User{login: $login, avatarUrl: $avatarUrl, followers: $followers, following: $following, url: $url}';
  }

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'] as String;
    avatarUrl = json['avatar_url'] as String;
    followers = 0;
    following = 0;
    url = json['url'] as String;
  }
}
