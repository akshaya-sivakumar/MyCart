class LoginRequest {
  LoginRequest({
    required this.userName,
    required this.passWord,
  });
  late final String userName;
  late final String passWord;

  LoginRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    passWord = json['passWord'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userName'] = userName;
    _data['passWord'] = passWord;
    return _data;
  }
}
