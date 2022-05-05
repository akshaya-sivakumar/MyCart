class User {
  User({
    required this.userName,
    required this.passWord,
    required this.profile,
    required this.dateOfBirth,
  });
  late final String userName;
  late final String passWord;
  late final String profile;
  late final String dateOfBirth;
  
  User.fromJson(Map<String, dynamic> json){
    userName = json['userName'];
    passWord = json['passWord'];
    profile = json['profile'];
    dateOfBirth = json['dateOfBirth'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userName'] = userName;
    _data['passWord'] = passWord;
    _data['profile'] = profile;
    _data['dateOfBirth'] = dateOfBirth;
    return _data;
  }
}