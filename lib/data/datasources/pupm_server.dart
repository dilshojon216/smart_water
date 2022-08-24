import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/other/constants.dart';

class PumpServer {
  // final String _baseUrl = "http://185.196.214.190:8018/";

  Future<dynamic> getToken(String username, String password) async {
    try {
      String apiBase = await _getApiBase();
      var dao = Dio();
      var map = {};
      map['username'] = username;
      map['password'] = password;

      var response = await dao.postUri(
        Uri.parse("${apiBase}login"),
        data: map,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
        var sds = json.encode(response.data);
        return json.decode(sds);
      } else {
        throw response.statusCode.toString();
      }
    } catch (e) {
      if (e is DioError) {
        throw e.message;
      } else {
        throw e.toString();
      }
    }
  }

  Future<dynamic> getPumpStations(String token) async {
    try {
      String apiBase = await _getApiBase();
      var dao = Dio();
      dao.options.baseUrl = apiBase;
      dao.options.headers = {
        "Authorization": "Bearer $token",
      };
      var response = await dao.get("station");
      if (response.statusCode == HttpStatus.ok) {
        var sds = json.encode(response.data);
        print(jsonDecode(sds));
        return json.decode(sds);
      } else {
        throw Exception(json.decode(response.data));
      }
    } catch (e) {
      if (e is DioError) {
        throw e.message;
      } else {
        throw e.toString();
      }
    }
  }

  Future<String> getAPIMqttPump() async {
    //use a Async-await function to get the data
    final prefs = await SharedPreferences.getInstance();
    String? api = prefs.getString(APIBASE2);

    if (api == "" || api == null) {
      final data = await FirebaseFirestore.instance
          .collection("api_pump_mqtt")
          .doc("Nu9AHoehWbSPuUTUO9Mi")
          .get(); //get the data

      api = data.data()!["name"];
      print(api);
      prefs.setString(APIBASE2, api!);
    }
    return api;
  }

  Future<String> _getApiBase() async {
    final prefs = await SharedPreferences.getInstance();
    String? urlSting = prefs.getString(APIBASE2);

    if (urlSting == null || urlSting.isEmpty) {
      return getAPIMqttPump();
    } else {
      return urlSting;
    }
  }
}
