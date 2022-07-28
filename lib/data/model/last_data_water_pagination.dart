class LastDataWaterPagination {
  late int totalCount;
  late int defaultPerPage;
  late int perPage;
  late int pageCount;
  late int currentPage;

  LastDataWaterPagination({
    required this.totalCount,
    required this.defaultPerPage,
    required this.perPage,
    required this.pageCount,
    required this.currentPage,
  });

  LastDataWaterPagination.fromJson(Map<String, dynamic> json) {
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
