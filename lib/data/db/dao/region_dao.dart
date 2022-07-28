import 'package:floor/floor.dart';

import '../../model/region.dart';

@dao
abstract class RegionDao {
  @Query('SELECT * FROM region')
  Future<List<Region?>> getAll();

  @Insert()
  Future<int> insert(Region demise);

  @Insert()
  Future<void> insertAll(List<Region> regions);

  @Update()
  Future<int> update(Region demise);
}
