import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../device_dashboard_water/widgets/card_second_widget.dart';
import '../../device_dashboard_water/widgets/card_wigdet.dart';
import '../../device_dashboard_water/widgets/data_value_widget.dart';
import 'last_mqtt_data_well.dart';

class StationsMqttWellData extends StatefulWidget {
  WellMqttModel mqttModel;

  StationsMqttWellData({
    Key? key,
    required this.mqttModel,
  }) : super(key: key);

  @override
  State<StationsMqttWellData> createState() => _StationsMqttWellDataState();
}

class _StationsMqttWellDataState extends State<StationsMqttWellData> {
  List<Region?> regions = [];
  bool isLoading = true;

  List<Organization?> districts = [];

  getRgions() async {
    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();

    final dao = database.regionDao;
    final result = await dao.getAll();

    setState(() {
      regions = result;
    });
  }

  @override
  void initState() {
    super.initState();

    getAllDistase();
    getRgions();
  }

  getAllDistase() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/balans_tashkilotlar.json");

    final jsonResult = json.decode(data);
    List<Organization> lastHoursDataModels = List<Organization>.from(
        jsonResult.map((element) => Organization.fromJson(element)));
    setState(() {
      districts = lastHoursDataModels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: statusBar(context),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Theme.of(context).primaryColor,
          iconSize: 20,
        ),
        elevation: 2,
        title: Text(
          widget.mqttModel.info!.i,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        widget.mqttModel.info != null ? getBatter() + "%" : "",
                        widget.mqttModel.info != null
                            ? batIcons(getBatter())
                            : Typicons.bat4),
                  ),
                  //Typicons.bat4
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        widget.mqttModel.info != null ? "${getSignal()}%" : "",
                        widget.mqttModel.info != null
                            ? sigalIcon(getSignal())
                            : Icons.signal_cellular_alt_sharp),
                  ),
                  //Icons.signal_cellular_alt_sharp,
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        widget.mqttModel.info != null ? getTemp() + "°C" : "",
                        Typicons.temperatire),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, right: 2),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  cardSecondWidget(
                      context,
                      LocaleKeys.more_mqtt_text_4.tr(),
                      widget.mqttModel.data != null ? getSath() : "",
                      'assets/images/water_level.png'),
                  cardSecondWidget(
                      context,
                      LocaleKeys.well_data_text_2.tr(),
                      widget.mqttModel.data != null ? getTemp2() : "",
                      'assets/images/thermometer.png'),
                  //Typicons.water
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, right: 2),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  cardSecondWidget(
                      context,
                      LocaleKeys.well_data_text_3.tr(),
                      widget.mqttModel.data != null ? getShorlanish() : "",
                      'assets/images/speed_water.png',
                      asad: 4),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  //Typicons.water
                ],
              ),
            ),
            dataValueWidget(context, LocaleKeys.viloyat_titel.tr(),
                widget.mqttModel.info != null ? getRegion() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.tuman_title.tr(),
                widget.mqttModel.info != null ? getDistrict() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.kanal_nomi.tr(),
                widget.mqttModel.info != null ? getName() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.id_text.tr(),
                widget.mqttModel.info != null ? getID() : "", 5, 5),
            GestureDetector(
              onTap: () {
                goMaps();
              },
              child: dataValueWidget(context, "Location:",
                  widget.mqttModel.info != null ? getLocation() : "", 5, 7),
            ),
            dataValueWidget(context, LocaleKeys.info_vaqt.tr(),
                widget.mqttModel.info != null ? getTime() : "", 5, 5),
          ],
        ),
      ),
    );
  }

  goMaps() {
    getLogiton();
    if (lang != "" && lat != "") {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lang,$lat';
      launchUrl(Uri.parse(googleUrl));
    }
  }

  getTemp2() {
    try {
      int sath = int.parse(widget.mqttModel.data!.q);
      return "${(sath / 10.0).toStringAsFixed(2)} °C";
    } catch (e) {
      print(e);
      return "";
    }
  }

  getSesnorType() {
    try {
      String fsdsd = "";

      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSiganlBlutooth() {
    try {
      String fsdsd = "";

      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getTime() {
    try {
      String fsdsd = "";
      if (widget.mqttModel.info != null) {
        fsdsd = widget.mqttModel.info!.t;
      }
      if (fsdsd != "") {
        return timeConvertMqtt(fsdsd);
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getLevel() {
    try {
      String fsdsd = "";

      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getProshibka() {
    try {
      String fsdsd = "";

      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getLocation() {
    try {
      String loction = "";
      if (widget.mqttModel.info != null) {
        loction = widget.mqttModel.info!.p6;
      }
      if (loction != "") {
        return loction;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  String lang = "";
  String lat = "";
  getLogiton() {
    try {
      String sdsdwsd = getLocation();
      if (sdsdwsd != "") {
        var sdsd = sdsdwsd.split(",");
        if (sdsd.length > 5) {
          lang = sdsd[3];
          lat = sdsd[4];
        }
        print(sdsd);
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  sigalIcon(String signal) {
    try {
      int batteryInt = int.parse(signal.substring(0, signal.indexOf(",")));

      if (batteryInt >= 0 && batteryInt <= 10) {
        return Icons.signal_cellular_alt_1_bar;
      } else if (batteryInt > 10 && batteryInt <= 18) {
        return Icons.signal_cellular_alt_2_bar;
      } else if (batteryInt > 18 && batteryInt <= 32) {
        return Icons.signal_cellular_alt;
      }
    } catch (e) {
      print(e.toString());
      return Icons.signal_cellular_alt_sharp;
    }
  }

  getID() {
    try {
      String id = "";
      if (widget.mqttModel.info != null) {
        id = widget.mqttModel.info!.p16;
      }
      if (id != "") {
        return id;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getRegion() {
    try {
      String region = "";
      if (widget.mqttModel.info != null) {
        region = widget.mqttModel.info!.p1;
      }

      if (region != "") {
        Region? region1 =
            regions.firstWhere((element) => element!.id == int.parse(region));
        return region1!.name;
      } else {
        return region;
      }
    } catch (e) {
      return widget.mqttModel.info!.p1;
    }
  }

  getPhone() {
    try {
      String phone = "";
      if (phone != "") {
        return phone;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getDistrict() {
    try {
      String district = "";
      if (widget.mqttModel.info != null) {
        district = widget.mqttModel.info!.p2;
      }
      if (district != "") {
        Organization? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.name;
      } else {
        return "";
      }
    } catch (e) {
      return widget.mqttModel.info!.p2;
    }
  }

  getName() {
    try {
      String name = "";
      if (widget.mqttModel.info != null) {
        name = widget.mqttModel.info!.p3;
      }
      if (name != "") {
        return name;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSignal() {
    String signal = "";
    if (widget.mqttModel.info != null) {
      signal = widget.mqttModel.info!.p9;
    }
    if (signal != "") {
      return signal;
    } else {
      return "";
    }
  }

  batIcons(String battery) {
    try {
      int batteryInt = int.parse(battery);
      if (batteryInt >= 0 && batteryInt <= 25) {
        return Typicons.bat1;
      } else if (batteryInt > 25 && batteryInt <= 50) {
        return Typicons.bat2;
      } else if (batteryInt > 50 && batteryInt <= 75) {
        return Typicons.bat3;
      } else if (batteryInt > 75 && batteryInt <= 100) {
        return Typicons.bat4;
      }
    } catch (e) {
      return Typicons.bat4;
    }
  }

  getSath() {
    String sath = "";
    if (widget.mqttModel.data != null) {
      sath = widget.mqttModel.data!.d;
    }
    if (sath != "") {
      return (int.parse(sath) / 10).toStringAsFixed(2);
    } else {
      return "";
    }
  }

  getBatter() {
    String battery = "";
    if (widget.mqttModel.info != null) {
      battery = widget.mqttModel.info!.p8;
    }
    if (battery != "") {
      return battery;
    } else {
      return "";
    }
  }

  getShorlanish() {
    try {
      double tempInt = int.parse(widget.mqttModel.data!.q) / 10.0;
      double dataSh = double.parse(widget.mqttModel.data!.q);

      double kFF = 1.0 + 0.02 * (tempInt - 25);
      double kF = dataSh / kFF;

      if (kF < 700) {
        if (kF == 0) {
          return "0 g/L";
        } else {
          return "${((kF - 27) / 350.0).toStringAsFixed(3)} g/L";
        }
      } else {
        return "${((kF - 40) / 380.0).toStringAsFixed(3)} g/l";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  timeConvertMqtt(String time) {
    //22/07/18,00:12:14+00
    try {
      String dateTime = "20${time}".replaceAll("/", "-").replaceAll(",", " ");
      DateTime date = DateTime.parse(dateTime);
      var jiffy1 = Jiffy(date, "YYYY-MM-dd HH:mm")
          .add(duration: const Duration(hours: 5));
      return jiffy1.format("yyyy-MM-dd HH:mm");
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  getTemp() {
    String temp = "";
    if (widget.mqttModel.info != null) {
      temp = widget.mqttModel.info!.p7;
    }
    if (temp != "") {
      return temp;
    } else {
      return "";
    }
  }
}
