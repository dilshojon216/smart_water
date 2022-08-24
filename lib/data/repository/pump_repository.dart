import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../datasources/pupm_server.dart';
import '../db/database/smart_water_database.dart';
import '../model/pump_stations.dart';

class PumpRepository {
  final PumpServer _pumpServer = PumpServer();

  Future<Either<String, String>> signInUser(
      String username, String passoword) async {
    try {
      var data = await _pumpServer.getToken(username, passoword);
      print(data["access_token"]);
      return Right(data["access_token"]);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, List<PumpStations>>> getPumpStations(
      String token) async {
    try {
      var data = await _pumpServer.getPumpStations(token);

      List<PumpStations> dataList = List<PumpStations>.from(
          data.map((element) => PumpStations.fromJson(element)));

      return Right(dataList);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> saveLocalBase(List<PumpStations> data) async {
    try {
      final database = await $FloorSmartWaterDatabase
          .databaseBuilder('app_database.db')
          .build();
      final dao = database.pumpStationsDao;
      await dao.insertAll(data);
      return const Right("true");
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, List<PumpStations>>> getLocalBase() async {
    try {
      final database = await $FloorSmartWaterDatabase
          .databaseBuilder('app_database.db')
          .build();
      final dao = database.pumpStationsDao;
      List<PumpStations> data = await dao.getAll();
      return Right(data);
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deleteLocalBase() async {
    try {
      final database = await $FloorSmartWaterDatabase
          .databaseBuilder('app_database.db')
          .build();
      final dao = database.pumpStationsDao;
      await dao.deleteAll();
      return const Right("true");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
