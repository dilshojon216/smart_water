class MqttUserToken {
  MqttUserToken({
    required this.id,
    required this.fio,
    required this.login,
    required this.password,
    required this.water,
    required this.well,
  });
  late final String id;
  late final String fio;
  late final String login;
  late final String password;
  late final String water;
  late final String well;

  MqttUserToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fio = json['fio'];
    login = json['login'];
    password = json['password'];
    water = json['water'];
    well = json['well'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['fio'] = fio;
    _data['login'] = login;
    _data['password'] = password;
    _data['water'] = water;
    _data['well'] = well;
    return _data;
  }
}
