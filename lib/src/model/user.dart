class User {
  String login;
  String avatarUrl;
  int followers;
  int following;

  User({this.login, this.avatarUrl, this.followers, this.following});  // {} - for named optional parameters

  @override
  String toString() {
    return 'User{login: $login, avatarUrl: $avatarUrl, followers: $followers, following: $following}';
  }

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'] as String;
    avatarUrl = json['avatar_url'] as String;
    followers = 0;
    following = 0;
  }
}
