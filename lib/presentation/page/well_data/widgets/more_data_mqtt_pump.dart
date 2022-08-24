import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../../../translations/locale_keys.g.dart';
import 'last_data_pump.dart';

class MoreDataMqttPump extends StatefulWidget {
  String title;
  List<PumpMqttData> pumpMqttData;
  MoreDataMqttPump({
    Key? key,
    required this.title,
    required this.pumpMqttData,
  }) : super(key: key);

  @override
  State<MoreDataMqttPump> createState() => _MoreDataMqttPumpState();
}

class _MoreDataMqttPumpState extends State<MoreDataMqttPump> {
  List<String> headerText = [
    LocaleKeys.more_mqtt_text_1.tr(),
    LocaleKeys.more_mqtt_text_2.tr(),
    LocaleKeys.more_mqtt_text_3.tr(),
    "${LocaleKeys.pump_text_2.tr()} (m3)",
    "${LocaleKeys.pump_text_3.tr()} (m3)",
    "Location:",
    "Topic:",
    LocaleKeys.vaqt_data_text_1.tr()
  ];

  @override
  void initState() {
    super.initState();
    getRgions();
    getAllDistase();
  }

  List<Region?> regions = [];
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

  getAllDistase() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/balans_tashkilot_nasos.json");

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
          widget.title,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: LazyDataTable(
        rows: widget.pumpMqttData.length - 1,
        columns: headerText.length - 1,
        tableDimensions: const LazyDataTableDimensions(
          cellHeight: 50,
          cellWidth: 200,
          topHeaderHeight: 50,
          leftHeaderWidth: 120,
        ),
        topHeaderBuilder: (i) => Center(
            child: Text(
          headerText[i + 1],
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
        leftHeaderBuilder: (i) => Center(
            child: Text(
          widget.pumpMqttData[i].stations.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
        dataCellBuilder: (i, j) => GestureDetector(
          onSecondaryTap: () {},
          onDoubleTap: () {
            setState(() {});
          },
          child: Center(
            child: Text(
              getData(widget.pumpMqttData[i], j),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        topLeftCornerWidget: Center(
            child: Text(
          headerText[0],
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      ),
    );
  }

  getData(PumpMqttData waterMqttModel, j) {
    switch (j) {
      case 0:
        return getRegion(waterMqttModel.stations.regionId);
      case 1:
        return getDistrict(waterMqttModel.stations.balanceId);
      case 2:
        return waterMqttModel.positiveFlow!.toStringAsFixed(2);
      case 3:
        return waterMqttModel.tutoleFlow!.toStringAsFixed(2);
      case 4:
        return "${waterMqttModel.stations.latitude}-${waterMqttModel.stations.longitude}";
      case 5:
        return waterMqttModel.stations.topic;
      case 6:
        return timeConvertMqtt(waterMqttModel.time!);
      default:
    }
  }

  timeConvertMqtt(String time) {
    //22/07/18,00:12:14+00
    try {
      String dateTime = "20${time}".replaceAll("/", "-").replaceAll(",", " ");
      DateTime date = DateTime.parse(dateTime);
      var jiffy1 = Jiffy(date, "YYYY-MM-dd HH:mm");
      return jiffy1.format("yyyy-MM-dd HH:mm");
    } catch (e) {
      print(e.toString());
      return time;
    }
  }

  getDistrict(int id) {
    try {
      Organization? district1 =
          districts.firstWhere((element) => element!.id == id);
      return district1!.name;
    } catch (e) {
      return id.toString();
    }
  }

  getRegion(int regionId) {
    try {
      Region? region1 =
          regions.firstWhere((element) => element!.id == regionId);
      return region1!.name;
    } catch (e) {
      return regionId.toString();
    }
  }
}
