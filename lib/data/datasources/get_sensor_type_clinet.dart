import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_water/data/db/database/smart_water_database.dart';
import 'package:smart_water/data/model/sensor_type.dart';

class GetSensorTypeClinet {
  CollectionReference users =
      FirebaseFirestore.instance.collection('sensorType');

  Future<List<String?>> getSensorType() async {
    try {
      List<String?> sensorType = [];
      QuerySnapshot querySnapshot = await users.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      allData.forEach((element) {
        var datajson = json.encode(element);
        sensorType.add(json.decode(datajson)['name']);
      });
      return sensorType;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<int> saveSensorType() async {
    List<String?> sensorType = await getSensorType();
    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();
    final dao = database.sensorTypeDao;

    for (var i = 0; i < sensorType.length; i++) {
      final result = await dao.insert(SensorType(name: sensorType[i]!));
      print(result);
    }
    return 0;
  }
}
