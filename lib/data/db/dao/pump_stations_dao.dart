import 'package:floor/floor.dart';

import '../../model/pump_stations.dart';

@dao
abstract class PumpStationsDao {
  @Query('SELECT * FROM pump_stations')
  Future<List<PumpStations>> getAll();

  @Insert()
  Future<int> insert(PumpStations pumpStation);

  @Insert()
  Future<void> insertAll(List<PumpStations> pumpStations);

  @Update()
  Future<int> update(PumpStations pumpStation);

  @Query('DELETE FROM pump_stations')
  Future<void> deleteAll();
}
