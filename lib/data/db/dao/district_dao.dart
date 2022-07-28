import 'package:floor/floor.dart';

import '../../model/district.dart';

@dao
abstract class DistrictDao {
  @Query('SELECT * FROM district')
  Future<List<District?>> getAll();

  @Query('SELECT * FROM district where regionId = :regionId')
  Future<List<District?>> getByRegionId(int regionId);

  @Insert()
  Future<int> insert(District demise);

  @Insert()
  Future<void> insertAll(List<District> districts);

  @Update()
  Future<int> update(District demise);
}
