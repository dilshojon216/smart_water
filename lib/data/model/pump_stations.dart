import 'package:floor/floor.dart';

@Entity(tableName: 'pump_stations')
class PumpStations {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final int regionId;
  final int discretId;
  final int balanceId;
  final String topic;

  PumpStations({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.regionId,
    required this.discretId,
    required this.balanceId,
    required this.topic,
  });

  PumpStations.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        regionId = json['region_id'],
        discretId = json['discret_id'],
        balanceId = json['balance_id'],
        topic = json['topic'];

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['region_id'] = regionId;
    _data['discret_id'] = discretId;
    _data['balance_id'] = balanceId;
    _data['topic'] = topic;
    return _data;
  }
}
