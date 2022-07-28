import 'water_stations_info.dart';

class WaterUserToken {
  late final String token;
  late final List<WaterStationsInfo> stations;
  late final String role;
  late final String fio;

  WaterUserToken({
    required this.token,
    required this.stations,
    required this.role,
    required this.fio,
  });

  WaterUserToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];

    stations = List.from(json['stations'])
        .map((e) => WaterStationsInfo.fromJson(e))
        .toList();
    role = json['role'];
    fio = json['fio'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['stations'] = stations.map((e) => e.toJson()).toList();
    _data['role'] = role;
    _data['fio'] = fio;
    return _data;
  }
}
