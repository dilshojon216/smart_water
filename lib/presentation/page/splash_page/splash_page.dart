import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/routes/app_routes.dart';

import '../../../core/other/constants.dart';
import '../../../data/datasources/get_district_clinet.dart';
import '../../../data/datasources/get_region_clinet.dart';
import '../../../data/datasources/get_sensor_type_clinet.dart';
import '../../../translations/locale_keys.g.dart';
import '../../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../water_data/water_data.dart';
import '../water_data/widgets/water_http_model.dart';
import '../water_data/widgets/water_mqtt_model.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/circular_indicator_widget.dart';
import 'widgets/logo_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SharedPreferences _prefs;
  String setLanguage = "";
  bool waterInstall = false;
  bool wellInstall = false;
  String typeWaterData = "1";
  Timer? _timer;

  initValue() async {
    _prefs = await SharedPreferences.getInstance();
    GetSensorTypeClinet getSensorTypeClinet = GetSensorTypeClinet();
    GetDistrictClient getDistrictClient = GetDistrictClient();
    GetRegionClient getRegionClient = GetRegionClient();
    String? firstInstall = _prefs.getString("firstInstall").toString();

    print(firstInstall);

    if (firstInstall != "true") {
      _prefs = await SharedPreferences.getInstance();

      String? sensorType = _prefs.getString("SensorType").toString();
      if (sensorType != "true") {
        int value = await getSensorTypeClinet.saveSensorType();
        if (value == 0) {
          _prefs.setString("SensorType", "true");
        }
      }
      String? district = _prefs.getString("District").toString();
      if (district != "true") {
        int value = await getDistrictClient.saveDistrict();
        if (value == 0) {
          _prefs.setString("District", "true");
        }
      }

      String? region = _prefs.getString("Region").toString();
      if (region != "true") {
        int value = await getRegionClient.saveRegion();
        if (value == 0) {
          _prefs.setString("Region", "true");
        }
      }
      _prefs.setString("firstInstall", "true");
    }
    initValue2();
  }

  initValue2() async {
    _prefs = await SharedPreferences.getInstance();
    setLanguage = _prefs.getString(LANGUAGE).toString();
    waterInstall = _prefs.getString("waterInstall").toString() == "true";
    int asdsadasdf = _prefs.getInt("valueWater") ?? 1;
    if (asdsadasdf == 1) {
      typeWaterData = "1";
      _prefs.setInt("valueWater", 1);
    } else {
      typeWaterData = "2";
    }
    print(typeWaterData);
  }

  @override
  void initState() {
    super.initState();
    initValue();

    _timer = Timer(const Duration(seconds: 2), () {
      if (setLanguage == "true") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SignInWaterCubit(),
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider<WaterMqttDataModel>(
                      create: (_) => WaterMqttDataModel()),
                  ChangeNotifierProvider<WaterHttpModel>(
                      create: (_) => WaterHttpModel()),
                ],
                child: WaterDataMain(
                    title: LocaleKeys.water_main_title.tr(),
                    isLogin: waterInstall,
                    typeData: typeWaterData),
              ),
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutesNames.selectLangPage,
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(context),
      body: Stack(
        children: [logoWidget(), circularIndicatorWidget(context, size)],
      ),
    );
  }
}
