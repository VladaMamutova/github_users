class User {
  String login;
  String name;
  String avatarUrl;
  int followers;
  int following;
  int id;

  User({
    this.login = '',
    this.name = '',
    this.avatarUrl = '',
    this.followers = 0,
    this.following = 0,
    this.id = 0,
  });

  @override
  String toString() {
    return 'User{login: $login, name: $name, avatarUrl: $avatarUrl, '
        'followers: $followers, following: $following}';
  }

  factory User.fromJson(dynamic json) {
    return User()
      ..login = json['login'] as String
      ..avatarUrl = json['avatar_url'] as String
      ..name = (json['name'] ?? '') as String
      ..followers = (json['followers'] ?? 0) as int
      ..following = (json['following'] ?? 0) as int
      ..id = (json['id'] ?? 0) as int;
  }
}
