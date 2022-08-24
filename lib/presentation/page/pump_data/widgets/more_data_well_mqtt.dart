import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import 'last_mqtt_data_well.dart';

class MoreDataWellMqtt extends StatefulWidget {
  String title;
  List<WellMqttModel> waterMqttModels;
  MoreDataWellMqtt({
    Key? key,
    required this.title,
    required this.waterMqttModels,
  }) : super(key: key);

  @override
  State<MoreDataWellMqtt> createState() => _MoreDataWellMqttState();
}

class _MoreDataWellMqttState extends State<MoreDataWellMqtt> {
  List<String> headerText = [
    LocaleKeys.dashboard_mqtt_text_7.tr(),
    LocaleKeys.more_mqtt_text_2.tr(),
    LocaleKeys.more_mqtt_text_3.tr(),
    LocaleKeys.more_mqtt_text_4.tr(),
    LocaleKeys.well_data_text_3.tr(),
    LocaleKeys.well_data_text_2.tr(),
    LocaleKeys.more_mqtt_text_7.tr(),
    LocaleKeys.more_mqtt_text_8.tr(),
    LocaleKeys.more_mqtt_text_9.tr(),
    "IMEI:",
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
          widget.title,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: LazyDataTable(
        rows: widget.waterMqttModels.length - 1,
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
          widget.waterMqttModels[i].info!.p3 == null
              ? ""
              : widget.waterMqttModels[i].info!.p3,
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
              getData(widget.waterMqttModels[i], j),
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

  getSath(String sath1) {
    String sath = sath1;
    if (sath != "") {
      return (int.parse(sath) / 10).toStringAsFixed(1);
    } else {
      return "";
    }
  }

  getData(WellMqttModel waterMqttModel, j) {
    switch (j) {
      case 0:
        return getRegion(waterMqttModel.info!.p1);
      case 1:
        return getDistrict(waterMqttModel.info!.p2);
      case 2:
        return getSath(waterMqttModel.data!.d);
      case 3:
        return getShorlanish(waterMqttModel);
      case 4:
        return getTemp2(waterMqttModel.data!.q);
      case 5:
        return getSignal(waterMqttModel.info!.p9);
      case 6:
        return getBatter(waterMqttModel.info!.p8);
      case 7:
        return getTemp(waterMqttModel.info!.p7);
      case 8:
        return waterMqttModel.info!.i;
      case 9:
        return timeConvertMqtt(waterMqttModel.data!.t);
      default:
    }
  }

  getTemp2(String temp) {
    try {
      int sath = int.parse(temp);
      return (sath / 10.0).toStringAsFixed(2);
    } catch (e) {
      print(e);
      return "";
    }
  }

  getShorlanish(WellMqttModel waterMqttModel) {
    try {
      double tempInt = int.parse(waterMqttModel.data!.q) / 10.0;
      double dataSh = double.parse(waterMqttModel.data!.q);

      double kFF = 1.0 + 0.02 * (tempInt - 25);
      double kF = dataSh / kFF;

      if (kF < 700) {
        if (kF == 0) {
          return "0 ";
        } else {
          return ((kF - 27) / 350.0).toStringAsFixed(3);
        }
      } else {
        return ((kF - 40) / 380.0).toStringAsFixed(3);
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
      return time;
    }
  }

  getDistrict(String id) {
    try {
      String district = id;

      if (district != "") {
        Organization? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.name;
      } else {
        return "";
      }
    } catch (e) {
      return id;
    }
  }

  getSignal(String id) {
    String signal = id;

    if (signal != "") {
      return signal;
    } else {
      return "";
    }
  }

  getPapravaka(String corec) {
    try {
      String corretion = corec;

      if (corretion != "") {
        return int.parse(corretion).toString();
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getBatter(String battry) {
    String battery = battry;

    if (battery != "") {
      return battery;
    } else {
      return "";
    }
  }

  getSarif(String dssd) {
    String sarif = dssd;

    if (sarif != "") {
      return (int.parse(sarif) / 1000.0).toStringAsFixed(3);
    } else {
      return "";
    }
  }

  getTemp(temms) {
    String temp = temms;

    if (temp != "") {
      return temp;
    } else {
      return "";
    }
  }

  getRegion(String regionId) {
    try {
      String region = regionId;

      if (region != "") {
        Region? region1 =
            regions.firstWhere((element) => element!.id == int.parse(region));
        return region1!.name;
      } else {
        return region;
      }
    } catch (e) {
      return regionId;
    }
  }
}
