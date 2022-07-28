import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../device_dashboard_water/widgets/card_second_widget.dart';
import '../../device_dashboard_water/widgets/card_wigdet.dart';
import '../../device_dashboard_water/widgets/data_value_widget.dart';
import 'message_send_device.dart';
import 'water_mqtt_all.dart';

class InfoWaterMqttData extends StatefulWidget {
  WaterMqttModel waterMqttModel;
  MqttServerClient? client;
  InfoWaterMqttData({
    Key? key,
    required this.waterMqttModel,
    this.client,
  }) : super(key: key);

  @override
  State<InfoWaterMqttData> createState() => _InfoWaterMqttDataState();
}

class _InfoWaterMqttDataState extends State<InfoWaterMqttData> {
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
        actions: [
          IconButton(
            onPressed: () {
              if (widget.client != null) {
                showInfo();
              }
            },
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            iconSize: 20,
          ),
        ],
        elevation: 2,
        title: Text(
          widget.waterMqttModel.info!.i,
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
                        widget.waterMqttModel.info != null
                            ? getBatter() + "%"
                            : "",
                        widget.waterMqttModel.info != null
                            ? batIcons(getBatter())
                            : Typicons.bat4),
                  ),
                  //Typicons.bat4
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        widget.waterMqttModel.info != null
                            ? "${getSignal()}%"
                            : "",
                        widget.waterMqttModel.info != null
                            ? sigalIcon(getSignal())
                            : Icons.signal_cellular_alt_sharp),
                  ),
                  //Icons.signal_cellular_alt_sharp,
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        widget.waterMqttModel.info != null
                            ? getTemp() + "°C"
                            : "",
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
                      widget.waterMqttModel.data != null ? getSath() : "",
                      'assets/images/water_level.png'),
                  cardSecondWidget(
                      context,
                      LocaleKeys.more_mqtt_text_5.tr(),
                      widget.waterMqttModel.data != null ? getSarif() : "",
                      'assets/images/speed_water.png'),
                  //Typicons.water
                ],
              ),
            ),
            dataValueWidget(context, LocaleKeys.viloyat_titel.tr(),
                widget.waterMqttModel.info != null ? getRegion() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.tuman_title.tr(),
                widget.waterMqttModel.info != null ? getDistrict() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.kanal_nomi.tr(),
                widget.waterMqttModel.info != null ? getName() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.id_text.tr(),
                widget.waterMqttModel.info != null ? getID() : "", 5, 5),
            dataValueWidget(context, LocaleKeys.paprvaka_title.tr(),
                widget.waterMqttModel.info != null ? getPapravaka() : "", 5, 5),
            GestureDetector(
              onTap: () {
                goMaps();
              },
              child: dataValueWidget(
                  context,
                  "Location:",
                  widget.waterMqttModel.info != null ? getLocation() : "",
                  5,
                  7),
            ),
            dataValueWidget(context, LocaleKeys.info_vaqt.tr(),
                widget.waterMqttModel.info != null ? getTime() : "", 5, 5),
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

  getLocation() {
    try {
      String loction = "";
      if (widget.waterMqttModel.info != null) {
        loction = widget.waterMqttModel.info!.p6;
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
      if (widget.waterMqttModel.info != null) {
        fsdsd = widget.waterMqttModel.info!.t;
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

  sigalIcon(String signal) {
    try {
      int batteryInt = int.parse(signal);

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
      if (widget.waterMqttModel.info != null) {
        id = widget.waterMqttModel.info!.p16;
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

  getPapravaka() {
    try {
      String corretion = "";
      if (widget.waterMqttModel.data != null) {
        corretion = widget.waterMqttModel.data!.c;
      }
      if (corretion != "") {
        return corretion;
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
      if (widget.waterMqttModel.info != null) {
        region = widget.waterMqttModel.info!.p1;
      }

      if (region != "") {
        Region? region1 =
            regions.firstWhere((element) => element!.id == int.parse(region));
        return region1!.name;
      } else {
        return region;
      }
    } catch (e) {
      return widget.waterMqttModel.info!.p1;
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
      if (widget.waterMqttModel.info != null) {
        district = widget.waterMqttModel.info!.p2;
      }
      if (district != "") {
        Organization? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.name;
      } else {
        return "";
      }
    } catch (e) {
      return widget.waterMqttModel.info!.p2;
    }
  }

  getName() {
    try {
      String name = "";
      if (widget.waterMqttModel.info != null) {
        name = widget.waterMqttModel.info!.p3;
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
    if (widget.waterMqttModel.info != null) {
      signal = widget.waterMqttModel.info!.p9;
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
    if (widget.waterMqttModel.data != null) {
      sath = widget.waterMqttModel.data!.d;
    }
    if (sath != "") {
      return (int.parse(sath) / 10).toStringAsFixed(1);
    } else {
      return "";
    }
  }

  getBatter() {
    String battery = "";
    if (widget.waterMqttModel.info != null) {
      battery = widget.waterMqttModel.info!.p8;
    }
    if (battery != "") {
      return battery;
    } else {
      return "";
    }
  }

  getSarif() {
    String sarif = "";
    if (widget.waterMqttModel.data != null) {
      sarif = widget.waterMqttModel.data!.v;
    }
    if (sarif != "") {
      return (int.parse(sarif) / 1000.0).toStringAsFixed(3);
    } else {
      return "";
    }
  }

  getTemp() {
    String temp = "";
    if (widget.waterMqttModel.info != null) {
      temp = widget.waterMqttModel.info!.p7;
    }
    if (temp != "") {
      return temp;
    } else {
      return "";
    }
  }

  void showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Xabar jo'natish",
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: MessageSendDevice(
                  info: widget.waterMqttModel.info!,
                  mqttData: widget.waterMqttModel.data!,
                  client: widget.client),
            );
          },
        );
      },
    );
  }
}
