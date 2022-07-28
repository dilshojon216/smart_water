import 'package:flutter/material.dart';

import 'water_mqtt_all.dart';

class WaterMqttDataModel extends ChangeNotifier {
  List<WaterMqttModel> waterMqttModels = [];
  int countList = 0;

  void changeData(List<WaterMqttModel> waterMqttModels1, int count) {
    print('changeData');
    countList = count;
    waterMqttModels = waterMqttModels1;
    notifyListeners();
  }

  void changeCount(int count) {
    countList = count;
    notifyListeners();
  }

  List<WaterMqttModel> get getWaterMqttModels => waterMqttModels;
  int get getCountList => countList;
}
