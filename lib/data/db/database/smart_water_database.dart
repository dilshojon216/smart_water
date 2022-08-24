import 'dart:async';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';

import '../../model/district.dart';
import '../../model/pump_stations.dart';
import '../../model/region.dart';
import '../../model/sensor_type.dart';
import '../../model/type_converter.dart';
import '../../model/water_info.dart';
import '../../model/water_stations_data.dart';
import '../dao/district_dao.dart';
import '../dao/pump_stations_dao.dart';
import '../dao/region_dao.dart';
import '../dao/sensor_type_dao.dart';
part 'smart_water_database.g.dart';

@Database(
  version: 1,
  entities: [
    SensorType,
    District,
    Region,
    PumpStations,
  ],
)
@TypeConverters([WaterStationsDataConvert])
abstract class SmartWaterDatabase extends FloorDatabase {
  SensorTypeDao get sensorTypeDao;
  DistrictDao get districtDao;
  RegionDao get regionDao;
  PumpStationsDao get pumpStationsDao;
}
