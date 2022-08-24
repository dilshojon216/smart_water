import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/other/constants.dart';
import '../model/last_data_water.dart';
import '../model/mqtt_user_token.dart';
import '../model/water_data_month.dart';
import '../model/water_data_ten_day.dart';
import '../model/water_data_today.dart';
import '../model/water_data_year.dart';
import '../model/water_user_token.dart';
import 'package:http/http.dart' as http;

class WaterClinet {
  Future<WaterUserToken> getUserToken(String username, String password) async {
    try {
      String apiBase = await _getApiBase();

      var response = await http.post(Uri.parse("${apiBase}login"),
          body: {"username": username, "password": password});
      if (response.statusCode == 200) {
        if (response.body != "false") {
          var data = json.decode(response.body);

          return WaterUserToken.fromJson(data);
        } else {
          throw Exception('Login yoki parol  xato kiriting!');
        }
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<MqttUserToken> getUserMqttToken(
      String username, String password) async {
    try {
      String apiBase = await _getApiMqttBase();
      var map = <String, dynamic>{};
      map['username'] = username;
      map['password'] = password;
      print(apiBase);
      var response = await http.post(Uri.parse(apiBase), body: map);
      if (response.statusCode == 200) {
        if (response.body != "false") {
          var data = json.decode(response.body);

          return MqttUserToken.fromJson(data);
        } else {
          throw Exception('Login yoki parol  xato kiriting!');
        }
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  static const LASTDATA_LIMIT = 10;
  Future<LastDataWater> getLastData(String? token, int page) async {
    try {
      String apiBase = await _getApiBase();
      var response = await http.get(
        Uri.parse("${apiBase}v1/stations?page=$page&per-page=$LASTDATA_LIMIT"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        return LastDataWater.fromJson(data);
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  static const LASTDATA_LIMIT1 = 50;
  Future<LastDataWater> getLastBack(
    String? token,
    int page,
  ) async {
    try {
      String apiBase = await _getApiBase();
      var response = await http.get(
        Uri.parse("${apiBase}v1/stations?page=$page&per-page=$LASTDATA_LIMIT1"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        return LastDataWater.fromJson(data);
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<WaterDataToyday> getWaterDataToyday(
      String? token, String? id, String date) async {
    try {
      String apiBase = await _getApiBase();
      var response =
          await http.post(Uri.parse("${apiBase}v1/data/soatlik"), headers: {
        "Authorization": "Bearer $token",
      }, body: {
        "st_id": id,
        "day": date
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["message"] != null) {
          throw Exception(data["message"]);
        } else {
          return WaterDataToyday.fromJson(data);
        }
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<WaterDataTenDay> getWaterDataTenDay(
      String? token, String? id, String date) async {
    try {
      String apiBase = await _getApiBase();
      var response =
          await http.post(Uri.parse("${apiBase}v1/data/decada"), headers: {
        "Authorization": "Bearer $token",
      }, body: {
        "st_id": id,
        "year": date
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["message"] != null) {
          throw Exception(data["message"]);
        } else {
          return WaterDataTenDay.fromJson(data);
        }
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<WaterDataMonths> getWaterDataMonth(
      String? token, String? id, String date) async {
    try {
      String apiBase = await _getApiBase();
      var response =
          await http.post(Uri.parse("${apiBase}v1/data/oylik"), headers: {
        "Authorization": "Bearer $token",
      }, body: {
        "st_id": id,
        "year": date
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["message"] != null) {
          throw Exception(data["message"]);
        } else {
          return WaterDataMonths.fromJson(data);
        }
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<WaterDatasYear> getWaterDataYear(
    String? token,
    String? id,
  ) async {
    try {
      String apiBase = await _getApiBase();
      var response =
          await http.post(Uri.parse("${apiBase}v1/data/yillik"), headers: {
        "Authorization": "Bearer $token",
      }, body: {
        "st_id": id,
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        return WaterDatasYear.fromJson(data);
      } else {
        throw Exception(response.body.toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getAPiHttpWater() async {
    //use a Async-await function to get the data
    final prefs = await SharedPreferences.getInstance();
    String? api = prefs.getString(APIBASE);

    if (api == "" || api == null) {
      final data = await FirebaseFirestore.instance
          .collection("api_http_water")
          .doc("ynSXNfNFPYLDNv9OWxw7")
          .get(); //get the data

      api = data.data()!["name"];
      print(api);
      prefs.setString(APIBASE, api!);
    }
    return api;
  }

  Future<String> _getApiBase() async {
    final prefs = await SharedPreferences.getInstance();
    String? urlSting = prefs.getString(APIBASE);

    if (urlSting == null || urlSting.isEmpty) {
      return getAPiHttpWater();
    } else {
      return urlSting;
    }
  }

  Future<String> getAPiMqttWater() async {
    //use a Async-await function to get the data
    final prefs = await SharedPreferences.getInstance();
    String? api = prefs.getString(APIBASE1);

    if (api == "" || api == null) {
      final data = await FirebaseFirestore.instance
          .collection("api_mqtt_water")
          .doc("qx9hYcCeuRolSwDwqpV9")
          .get(); //get the data

      api = data.data()!["name"];
      print(api);
      prefs.setString(APIBASE1, api!);
    }
    return api;
  }

  Future<String> _getApiMqttBase() async {
    final prefs = await SharedPreferences.getInstance();
    String? urlSting = prefs.getString(APIBASE1);

    if (urlSting == null || urlSting.isEmpty) {
      return getAPiMqttWater();
    } else {
      return urlSting;
    }
  }
}
