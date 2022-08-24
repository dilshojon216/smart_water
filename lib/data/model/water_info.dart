import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import 'type_converter.dart';
import 'water_stations_data.dart';

@entity
class WaterInfo extends Equatable {
  @PrimaryKey(autoGenerate: true)
  late int? id;
  late String? name;
  late int? region;
  late int? district;
  late int? status;
  late String? lat;
  late String? lon;
  late String? simkart;
  late String? code;
  @TypeConverters([WaterStationsDataConvert])
  late WaterStationsData? data;
  WaterInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? -999 : int.parse(json['id'].toString());
    name = json['name'] == null ? '' : json['name'].toString();
    region =
        json['region'] == null ? -999 : int.parse(json['region'].toString());
    district = json['district'] == null
        ? -999
        : int.parse(json['district'].toString());
    status =
        json['status'] == null ? -999 : int.parse(json['status'].toString());
    lat = json['lat'] == null ? '' : json['lat'].toString();
    lon = json['lon'] == null ? '' : json['lon'].toString();
    simkart = json['simkart'] == null ? '' : json['simkart'].toString();
    code = json['code'] == null ? '' : json['code'].toString();
    data = json["data"] == null
        ? WaterStationsData(
            corec: -999,
            id: -999,
            createdAt: "",
            level: -999,
            stId: -999,
            time: "",
            volume: -999)
        : WaterStationsData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['region'] = region;
    _data['district'] = district;
    _data['status'] = status;
    _data['lat'] = lat;
    _data['lon'] = lon;
    _data['simkart'] = simkart;
    _data['code'] = code;
    _data["data"] = data!.toJson();
    return _data;
  }

  static listJson(List<WaterInfo> list) {
    List<Map<String, dynamic>> _list = [];
    for (var item in list) {
      if (item.data != null) {
        _list.add(item.toJson());
      }
    }
    return _list;
  }

  @override
  List<Object> get props =>
      [id!, name!, region!, district!, status!, lat!, lon!, simkart!, code!];
}
