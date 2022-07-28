class MqttWaringData {
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

  MqttWaringData({
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
  });

  MqttWaringData.fromJson(Map<String, dynamic> json) {
    i = json['i'];
    t = json['t'];
    p1 = json['p1'];
    p2 = json['p2'];
    p3 = json['p3'];
    p4 = json['p4'];
    p5 = json['p5'];
    p6 = json['p6'];
    p7 = json['p7'];
    p8 = json['p8'] == null ? '' : json['p8'];
  }
}
