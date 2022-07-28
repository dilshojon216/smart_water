class WaterMqttData {
  late final String i;
  late final String t;
  late final String d;
  late final String v;
  late final String c;
  WaterMqttData.fromJson(Map<String, dynamic> json) {
    i = json['i'];
    t = json['t'];
    d = json['d'];
    v = json['v'];
    c = json['c'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['i'] = i;
    _data['t'] = t;
    _data['d'] = d;
    _data['v'] = v;
    _data['c'] = c;
    return _data;
  }
}
