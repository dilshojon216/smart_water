import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class WaterStationsData extends Equatable {
  late int? id;
  late int? stId;
  late double? level;
  late double? volume;
  late String? time;
  late int? corec;
  late String? createdAt;

  WaterStationsData({
    required this.id,
    required this.stId,
    required this.level,
    required this.volume,
    required this.time,
    required this.corec,
    required this.createdAt,
  });

  WaterStationsData.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? -999 : int.parse(json['id'].toString());
    stId = json['st_id'] == null ? -999 : int.parse(json['st_id'].toString());
    level =
        json['level'] == null ? -999 : double.parse(json['level'].toString());
    volume =
        json['volume'] == null ? -999 : double.parse(json['volume'].toString());
    time = json['time'] == null ? '' : json['time'].toString();
    corec = json['corec'] == null ? -999 : int.parse(json['corec'].toString());
    createdAt = json['created_at'] == null ? '' : json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['st_id'] = stId;
    _data['level'] = level;
    _data['volume'] = volume;
    _data['time'] = time;
    _data['corec'] = corec;
    _data['created_at'] = createdAt;
    return _data;
  }

  @override
  List<Object?> get props => [id, stId, level, volume, time, corec, createdAt];
}
