class WellMqttData {
  WellMqttData({
    required this.i,
    required this.t,
    required this.d,
    required this.r,
    required this.q,
  });
  late final String i;
  late final String t;
  late final String d;
  late final String r;
  late final String q;

  WellMqttData.fromJson(Map<String, dynamic> json) {
    i = json['i'];
    t = json['t'];
    d = json['d'];
    r = json['r'];
    q = json['q'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['i'] = i;
    _data['t'] = t;
    _data['d'] = d;
    _data['r'] = r;
    _data['q'] = q;
    return _data;
  }
}
