import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/model/water_info.dart';

class WaterHttpModel extends ChangeNotifier {
  List<WaterInfo> waterInfoList = [];

  void getWaterInfoeData() async {
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("stations");
      print(token);
      var data = jsonDecode(token!);

      List<WaterInfo> stations =
          List.from(data.map((x) => WaterInfo.fromJson(x)).toList());

      waterInfoList = stations;
      notifyListeners();
    } catch (e) {
      print("${e.toString()}sdsdsd");
    }
  }

  void changeWaterInfo(List<WaterInfo> value) {
    waterInfoList = value;
    notifyListeners();
  }

  List<WaterInfo> get waterInfoLists => waterInfoList;
}
