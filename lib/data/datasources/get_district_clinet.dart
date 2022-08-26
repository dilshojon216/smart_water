import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_water/data/model/district.dart';

import '../db/database/smart_water_database.dart';

class GetDistrictClient {
  Future<List<District?>> getSensorType() async {
    try {
      const String APIBASE = "https://suvombor.uz:5002/api/";
      var response =
          await http.get(Uri.parse("${APIBASE}district/getDistrict"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<District> lastHoursDataModels = List<District>.from(
            data.map((element) => District.fromJson(element)));
        return lastHoursDataModels;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<int> saveDistrict() async {
    List<District?> sensorType = await getSensorType();

    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();
    final dao = database.districtDao;
    List<District> newData = [];
    sensorType.forEach((element) {
      newData.add(District(name: element!.name, regionId: element.regionId));
    });

    await dao.insertAll(newData);

    return 0;
  }
}
