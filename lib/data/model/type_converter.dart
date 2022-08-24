import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:smart_water/data/model/water_stations_data.dart';

class WaterStationsDataConvert
    extends TypeConverter<WaterStationsData, String> {
  @override
  WaterStationsData decode(String databaseValue) {
    if (databaseValue == "") {
      return WaterStationsData(
          corec: -999,
          id: -999,
          createdAt: "",
          level: -999,
          stId: -999,
          time: "",
          volume: -999);
    }
    return WaterStationsData.fromJson(json.decode(databaseValue));
  }

  @override
  String encode(WaterStationsData value) {
    return json.encode(value.toJson());
  }
}
