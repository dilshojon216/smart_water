class WaterMqttInfo {
  late final String i;
  late final String t;
  late final String p1;
  late final String p2;
  late final String p3;
  late final String p4;
  late final String p5;
  late final String p6;
  late final String p7;
  late final String p8;
  late final String p9;
  late final String p10;
  late final String p11;
  late final String p12;
  late final String p13;
  late final String p14;
  late final String p15;
  late final String p16;
  String? p17;

  WaterMqttInfo({
    required this.i,
    required this.t,
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
    required this.p5,
    required this.p6,
    required this.p7,
    required this.p8,
    required this.p9,
    required this.p10,
    required this.p11,
    required this.p12,
    required this.p13,
    required this.p14,
    required this.p15,
    required this.p16,
    this.p17,
  });

  WaterMqttInfo.fromJson(Map<String, dynamic> json) {
    i = json['i'];
    t = json['t'];
    p1 = json['p1'];
    p2 = json['p2'];
    p3 = json['p3'];
    p4 = json['p4'];
    p5 = json['p5'];
    p6 = json['p6'];
    p7 = json['p7'];
    p8 = json['p8'];
    p9 = json['p9'];
    p10 = json['p10'];
    p11 = json['p11'];
    p12 = json['p12'];
    p13 = json['p13'];
    p14 = json['p14'];
    p15 = json['p15'];
    p16 = json['p16'];
    p17 = json['p17'] == null ? null : json['p17'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['i'] = i;
    _data['t'] = t;
    _data['p1'] = p1;
    _data['p2'] = p2;
    _data['p3'] = p3;
    _data['p4'] = p4;
    _data['p5'] = p5;
    _data['p6'] = p6;
    _data['p7'] = p7;
    _data['p8'] = p8;
    _data['p9'] = p9;
    _data['p10'] = p10;
    _data['p11'] = p11;
    _data['p12'] = p12;
    _data['p13'] = p13;
    _data['p14'] = p14;
    _data['p15'] = p15;
    _data['p16'] = p16;
    return _data;
  }
}
