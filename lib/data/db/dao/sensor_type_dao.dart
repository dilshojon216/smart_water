import 'package:floor/floor.dart';
import 'package:smart_water/data/model/sensor_type.dart';

@dao
abstract class SensorTypeDao {
  @Query('SELECT * FROM sensorType')
  Future<List<SensorType?>> getAll();

  @Insert()
  Future<int> insert(SensorType demise);
  @Insert()
  Future<void> insertAll(List<SensorType> data);

  @Update()
  Future<int> update(SensorType demise);

  @Query("DELETE FROM sensorType")
  Future<void> deletetAll();
}
