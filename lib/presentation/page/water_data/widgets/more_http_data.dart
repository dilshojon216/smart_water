import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

import 'package:smart_water/data/model/water_info.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/district_http.dart';
import '../../../../data/model/region.dart';
import '../../../../translations/locale_keys.g.dart';

class MorehttpData extends StatefulWidget {
  String title;
  List<WaterInfo> waterMqttModels;
  MorehttpData({
    Key? key,
    required this.title,
    required this.waterMqttModels,
  }) : super(key: key);

  @override
  State<MorehttpData> createState() => _MorehttpDataState();
}

class _MorehttpDataState extends State<MorehttpData> {
  List<Region?> regions = [];
  List<DistrictHttp?> districts = [];
  List<String> headerText = [
    LocaleKeys.more_mqtt_text_1.tr(),
    LocaleKeys.more_mqtt_text_2.tr(),
    LocaleKeys.tuman_text.tr(),
    LocaleKeys.more_mqtt_text_4.tr(),
    LocaleKeys.more_mqtt_text_5.tr(),
    LocaleKeys.more_mqtt_text_6.tr(),
    LocaleKeys.phone_number.tr(),
    "IMEI:",
    LocaleKeys.vaqt_data_text_1.tr()
  ];

  @override
  void initState() {
    super.initState();
    getRgions();
    getAllDistase();
  }

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
        .loadString("assets/json/tumanlar_farhod.json");

    final jsonResult = json.decode(data);
    List<DistrictHttp> lastHoursDataModels = List<DistrictHttp>.from(
        jsonResult.map((element) => DistrictHttp.fromJson(element)));
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
          leftHeaderWidth: 150,
        ),
        topHeaderBuilder: (i) => Center(
            child: Text(
          headerText[i + 1],
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
        leftHeaderBuilder: (i) => Center(
            child: Text(
          widget.waterMqttModels[i].name!,
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

  getData(WaterInfo waterMqttModel, j) {
    switch (j) {
      case 0:
        return getRegion(waterMqttModel.region!.toString());
      case 1:
        return getDistrict(waterMqttModel.district!.toString());
      case 2:
        return (waterMqttModel.data!.level! * 100).toStringAsFixed(2);
      case 3:
        return waterMqttModel.data!.volume!.toString();
      case 4:
        return waterMqttModel.data!.corec!.toString();
      case 5:
        return waterMqttModel.simkart.toString();
      case 6:
        return waterMqttModel.code!.toString();
      case 7:
        return timeString(waterMqttModel.data!.time!.toString());
      default:
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

  getDistrict(String districtId) {
    try {
      String district = districtId;

      if (district != "") {
        DistrictHttp? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.tum_nomi;
      } else {
        return "";
      }
    } catch (e) {
      return districtId;
    }
  }

  timeString(String time) {
    if (time.length == 12) {
      return "${time.substring(0, 4)}-${time.substring(4, 6)}-${time.substring(6, 8)} ${time.substring(8, 10)}:${time.substring(10, 12)}";
    }
  }
}
