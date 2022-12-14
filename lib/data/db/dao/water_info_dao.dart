import 'package:floor/floor.dart';

import '../../model/water_info.dart';

@dao
abstract class WaterInfoDao {
  @Query('SELECT * FROM water_info')
  Future<List<WaterInfo?>> getAll();
  @Insert()
  Future<int> insert(WaterInfo demise);
  @Update()
  Future<int> update(WaterInfo demise);

  @Query('DELETE FROM water_info')
  Future<void> deleteAll();

  @Query('DELETE FROM water_info WHERE id = :id')
  Future<void> deleteById(int id);
}
