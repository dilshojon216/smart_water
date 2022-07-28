class WaterDataMonths {
  late final Pagination pagination;
  late final List<dynamic> mqttdata;

  WaterDataMonths({required this.pagination, required this.mqttdata});

  factory WaterDataMonths.fromJson(Map<String, dynamic> json) {
    return WaterDataMonths(
        pagination: Pagination.fromJson(json['pagination']),
        mqttdata: json['mqttdata']);
  }

  Map<String, dynamic> toJson() {
    return {'pagination': pagination.toJson(), 'mqttdata': mqttdata};
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
