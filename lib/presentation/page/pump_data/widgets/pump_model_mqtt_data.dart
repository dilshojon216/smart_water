import 'package:flutter/material.dart';

import 'last_mqtt_data_well.dart';

class PumpModelMqttData extends ChangeNotifier {
  List<WellMqttModel> waterMqttModels = [];
  int countList = 0;

  void changeData(List<WellMqttModel> waterMqttModels1, int count) {
    print('changeData');
    waterMqttModels = waterMqttModels1;
    print(waterMqttModels.length);
    countList = count;
    notifyListeners();
  }

  List<WellMqttModel> get getWaterMqttModels => waterMqttModels;
  int get getCountList => countList;
}
