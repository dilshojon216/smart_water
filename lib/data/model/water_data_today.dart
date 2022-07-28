class WaterDataToyday {
  late final Pagination pagination;
  late final List<MqttdataToyday> mqttdata;

  WaterDataToyday({
    required this.pagination,
    required this.mqttdata,
  });

  WaterDataToyday.fromJson(Map<String, dynamic> json) {
    pagination = Pagination.fromJson(json['pagination']);
    mqttdata = List.from(json['mqttdata'])
        .map((e) => MqttdataToyday.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pagination'] = pagination.toJson();
    _data['mqttdata'] = mqttdata.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Pagination {
  Pagination({
    required this.totalCount,
    required this.defaultPerPage,
    required this.perPage,
    required this.pageCount,
    required this.currentPage,
  });
  late final int totalCount;
  late final int defaultPerPage;
  late final int perPage;
  late final int pageCount;
  late final int currentPage;

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    defaultPerPage = json['defaultPerPage'];
    perPage = json['perPage'];
    pageCount = json['pageCount'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalCount'] = totalCount;
    _data['defaultPerPage'] = defaultPerPage;
    _data['perPage'] = perPage;
    _data['pageCount'] = pageCount;
    _data['currentPage'] = currentPage;
    return _data;
  }
}

class MqttdataToyday {
  MqttdataToyday({
    required this.stId,
    required this.level,
    required this.volume,
    required this.time,
  });
  late int stId;
  late double? level;
  late double? volume;
  late String time;

  MqttdataToyday.fromJson(Map<String, dynamic> json) {
    stId = json['st_id'];
    level = double.parse(json['level'].toString());
    volume = double.parse(json['volume'].toString());
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['st_id'] = stId;
    _data['level'] = level;
    _data['volume'] = volume;
    _data['time'] = time;
    return _data;
  }
}
