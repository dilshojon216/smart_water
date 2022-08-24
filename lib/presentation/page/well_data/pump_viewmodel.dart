import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/data/model/pump_stations.dart';

import '../../../data/repository/pump_repository.dart';
import 'widgets/last_data_pump.dart';

class PumpViewModel with ChangeNotifier {
  bool installBool1 = false;
  SharedPreferences? prefs;
  final PumpRepository _pumpRepository = PumpRepository();
  List<PumpStations> pumpStations = [];
  List<PumpMqttData> pumpMqttData = [];
  int subscribeCount = 0;

  PumpViewModel() {
    _init();
  }
  void _init() async {
    prefs = await SharedPreferences.getInstance();
    installBool1 = prefs!.getString("pumperInstall").toString() == "true";
    if (installBool1) {
      var data = await _pumpRepository.getLocalBase();

      data.fold((l) => print(l), (r) => pumpStations = r);
    }
    notifyListeners();
  }

  void setInstall(bool value) {
    installBool1 = value;
    prefs!.setString("pumperInstall", value.toString());
    notifyListeners();
  }

  void setPumpStations(List<PumpStations> value) {
    pumpStations = value;
    notifyListeners();
  }

  void getPumpStations1() async {
    var data = await _pumpRepository.getLocalBase();

    data.fold((l) => print(l), (r) => pumpStations = r);
    notifyListeners();
  }

  void changePumpMqttData(List<PumpMqttData> value, subscribeCount1) {
    pumpMqttData = value;
    subscribeCount = subscribeCount1;
    notifyListeners();
  }

  void clearPumpStation() async {
    await _pumpRepository.deleteLocalBase();
    notifyListeners();
  }

  bool get installBool => installBool1;
}
