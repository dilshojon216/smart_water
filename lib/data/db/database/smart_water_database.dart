import 'dart:async';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';

import '../../model/district.dart';
import '../../model/region.dart';
import '../../model/sensor_type.dart';
import '../../model/water_info.dart';
import '../dao/district_dao.dart';
import '../dao/region_dao.dart';
import '../dao/sensor_type_dao.dart';
import '../dao/water_info_dao.dart';
part 'smart_water_database.g.dart';

@Database(
  version: 1,
  entities: [
    SensorType,
    District,
    Region,
  ],
)
abstract class SmartWaterDatabase extends FloorDatabase {
  SensorTypeDao get sensorTypeDao;
  DistrictDao get districtDao;
  RegionDao get regionDao;
}
