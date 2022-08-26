import 'dart:convert';

import 'package:http/http.dart' as http;

import '../db/database/smart_water_database.dart';
import '../model/region.dart';

class GetRegionClient {
  Future<List<Region?>> getSensorType() async {
    try {
      const String APIBASE = "https://suvombor.uz:5002/api/";
      var response = await http.get(Uri.parse("${APIBASE}region/getReg"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Region> lastHoursDataModels =
            List<Region>.from(data.map((element) => Region.fromJson(element)));
        return lastHoursDataModels;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<int> saveRegion() async {
    List<Region?> sensorType = await getSensorType();
    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();
    final dao = database.regionDao;

    List<Region> newData = [];
    sensorType.forEach((element) {
      newData.add(Region(name: element!.name));
    });
    await dao.insertAll(newData);

    return 0;
  }
}
