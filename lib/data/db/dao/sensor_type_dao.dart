import 'package:floor/floor.dart';
import 'package:smart_water/data/model/sensor_type.dart';

@dao
abstract class SensorTypeDao {
  @Query('SELECT * FROM SensorType')
  Future<List<SensorType?>> getAll();

  @Insert()
  Future<int> insert(SensorType demise);
  @Update()
  Future<int> update(SensorType demise);
}
