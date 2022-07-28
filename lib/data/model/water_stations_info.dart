class WaterStationsInfo {
  WaterStationsInfo({
    required this.id,
    required this.nomi,
    required this.userId,
    required this.stations,
  });
  late final int id;
  late final String nomi;
  late final int userId;
  late final String stations;

  WaterStationsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomi = json['nomi'];
    userId = json['user_id'];
    stations = json['stations'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nomi'] = nomi;
    _data['user_id'] = userId;
    _data['stations'] = stations;
    return _data;
  }
}
