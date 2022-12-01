import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_water/data/model/district.dart';

import '../db/database/smart_water_database.dart';

class GetDistrictClient {
  Future<List<District?>> getSensorType() async {
    try {
      // ignore: constant_identifier_names
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
      throw e.toString();
    }
  }

  Future<int> saveDistrict() async {
    try {
      List<District?> sensorType = District.getDistricts();

      final database = await $FloorSmartWaterDatabase
          .databaseBuilder('app_database.db')
          .build();
      final dao = database.districtDao;
      List<District> newData = [];
      for (var element in sensorType) {
        newData.add(District(name: element!.name, regionId: element.regionId));
      }

      await dao.insertAll(newData);
      print("saved");
      return 0;
    } catch (e) {
      throw e.toString();
    }
  }
}
