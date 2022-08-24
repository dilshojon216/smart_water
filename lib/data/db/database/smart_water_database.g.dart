// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_water_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorSmartWaterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SmartWaterDatabaseBuilder databaseBuilder(String name) =>
      _$SmartWaterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SmartWaterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$SmartWaterDatabaseBuilder(null);
}

class _$SmartWaterDatabaseBuilder {
  _$SmartWaterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$SmartWaterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$SmartWaterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<SmartWaterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SmartWaterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SmartWaterDatabase extends SmartWaterDatabase {
  _$SmartWaterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SensorTypeDao? _sensorTypeDaoInstance;

  DistrictDao? _districtDaoInstance;

  RegionDao? _regionDaoInstance;

  PumpStationsDao? _pumpStationsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SensorType` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `District` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `regionId` INTEGER NOT NULL, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Region` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `pump_stations` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `regionId` INTEGER NOT NULL, `discretId` INTEGER NOT NULL, `balanceId` INTEGER NOT NULL, `topic` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SensorTypeDao get sensorTypeDao {
    return _sensorTypeDaoInstance ??= _$SensorTypeDao(database, changeListener);
  }

  @override
  DistrictDao get districtDao {
    return _districtDaoInstance ??= _$DistrictDao(database, changeListener);
  }

  @override
  RegionDao get regionDao {
    return _regionDaoInstance ??= _$RegionDao(database, changeListener);
  }

  @override
  PumpStationsDao get pumpStationsDao {
    return _pumpStationsDaoInstance ??=
        _$PumpStationsDao(database, changeListener);
  }
}

class _$SensorTypeDao extends SensorTypeDao {
  _$SensorTypeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sensorTypeInsertionAdapter = InsertionAdapter(
            database,
            'SensorType',
            (SensorType item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _sensorTypeUpdateAdapter = UpdateAdapter(
            database,
            'SensorType',
            ['id'],
            (SensorType item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SensorType> _sensorTypeInsertionAdapter;

  final UpdateAdapter<SensorType> _sensorTypeUpdateAdapter;

  @override
  Future<List<SensorType?>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM SensorType',
        mapper: (Map<String, Object?> row) =>
            SensorType(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<int> insert(SensorType demise) {
    return _sensorTypeInsertionAdapter.insertAndReturnId(
        demise, OnConflictStrategy.abort);
  }

  @override
  Future<int> update(SensorType demise) {
    return _sensorTypeUpdateAdapter.updateAndReturnChangedRows(
        demise, OnConflictStrategy.abort);
  }
}

class _$DistrictDao extends DistrictDao {
  _$DistrictDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _districtInsertionAdapter = InsertionAdapter(
            database,
            'District',
            (District item) => <String, Object?>{
                  'id': item.id,
                  'regionId': item.regionId,
                  'name': item.name
                }),
        _districtUpdateAdapter = UpdateAdapter(
            database,
            'District',
            ['id'],
            (District item) => <String, Object?>{
                  'id': item.id,
                  'regionId': item.regionId,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<District> _districtInsertionAdapter;

  final UpdateAdapter<District> _districtUpdateAdapter;

  @override
  Future<List<District?>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM district',
        mapper: (Map<String, Object?> row) => District(
            id: row['id'] as int?,
            name: row['name'] as String,
            regionId: row['regionId'] as int));
  }

  @override
  Future<List<District?>> getByRegionId(int regionId) async {
    return _queryAdapter.queryList('SELECT * FROM district where regionId = ?1',
        mapper: (Map<String, Object?> row) => District(
            id: row['id'] as int?,
            name: row['name'] as String,
            regionId: row['regionId'] as int),
        arguments: [regionId]);
  }

  @override
  Future<int> insert(District demise) {
    return _districtInsertionAdapter.insertAndReturnId(
        demise, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAll(List<District> districts) async {
    await _districtInsertionAdapter.insertList(
        districts, OnConflictStrategy.abort);
  }

  @override
  Future<int> update(District demise) {
    return _districtUpdateAdapter.updateAndReturnChangedRows(
        demise, OnConflictStrategy.abort);
  }
}

class _$RegionDao extends RegionDao {
  _$RegionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _regionInsertionAdapter = InsertionAdapter(
            database,
            'Region',
            (Region item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _regionUpdateAdapter = UpdateAdapter(
            database,
            'Region',
            ['id'],
            (Region item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Region> _regionInsertionAdapter;

  final UpdateAdapter<Region> _regionUpdateAdapter;

  @override
  Future<List<Region?>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM region',
        mapper: (Map<String, Object?> row) =>
            Region(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<int> insert(Region demise) {
    return _regionInsertionAdapter.insertAndReturnId(
        demise, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAll(List<Region> regions) async {
    await _regionInsertionAdapter.insertList(regions, OnConflictStrategy.abort);
  }

  @override
  Future<int> update(Region demise) {
    return _regionUpdateAdapter.updateAndReturnChangedRows(
        demise, OnConflictStrategy.abort);
  }
}

class _$PumpStationsDao extends PumpStationsDao {
  _$PumpStationsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _pumpStationsInsertionAdapter = InsertionAdapter(
            database,
            'pump_stations',
            (PumpStations item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'regionId': item.regionId,
                  'discretId': item.discretId,
                  'balanceId': item.balanceId,
                  'topic': item.topic
                }),
        _pumpStationsUpdateAdapter = UpdateAdapter(
            database,
            'pump_stations',
            ['id'],
            (PumpStations item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'regionId': item.regionId,
                  'discretId': item.discretId,
                  'balanceId': item.balanceId,
                  'topic': item.topic
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PumpStations> _pumpStationsInsertionAdapter;

  final UpdateAdapter<PumpStations> _pumpStationsUpdateAdapter;

  @override
  Future<List<PumpStations>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM pump_stations',
        mapper: (Map<String, Object?> row) => PumpStations(
            id: row['id'] as int?,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            regionId: row['regionId'] as int,
            discretId: row['discretId'] as int,
            balanceId: row['balanceId'] as int,
            topic: row['topic'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM pump_stations');
  }

  @override
  Future<int> insert(PumpStations pumpStation) {
    return _pumpStationsInsertionAdapter.insertAndReturnId(
        pumpStation, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAll(List<PumpStations> pumpStations) async {
    await _pumpStationsInsertionAdapter.insertList(
        pumpStations, OnConflictStrategy.abort);
  }

  @override
  Future<int> update(PumpStations pumpStation) {
    return _pumpStationsUpdateAdapter.updateAndReturnChangedRows(
        pumpStation, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _waterStationsDataConvert = WaterStationsDataConvert();
