import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/data/model/district.dart';

import 'package:smart_water/data/model/water_info.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/district_http.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../device_dashboard_water/widgets/card_second_widget.dart';
import '../../device_dashboard_water/widgets/data_value_widget.dart';

class InfoStationAll extends StatefulWidget {
  WaterInfo info;

  InfoStationAll({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  State<InfoStationAll> createState() => _InfoStationAllState();
}

class _InfoStationAllState extends State<InfoStationAll> {
  List<Region?> regions = [];
  List<DistrictHttp?> districts = [];

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
  void initState() {
    getRgions();
    getAllDistase();
    super.initState();
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
          "${widget.info.name}",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        actions: [
          Container(
            width: 50,
            height: 30,
            margin: const EdgeInsets.all(10),
            color: widget.info.data == null
                ? Colors.red
                : colorLine(dayString(widget.info.data!.time)),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, right: 2),
            height: MediaQuery.of(context).size.height * 0.15,
            child: Row(
              children: [
                cardSecondWidget(
                    context,
                    LocaleKeys.suv_sathi_data_text_2.tr().replaceAll("\n", ""),
                    widget.info.data != null
                        ? widget.info.data!.level!.toStringAsFixed(3)
                        : "",
                    'assets/images/water_level.png'),
                cardSecondWidget(
                    context,
                    LocaleKeys.suv_sarfi_data_text.tr(),
                    widget.info.data != null
                        ? widget.info.data!.volume!.toStringAsFixed(3)
                        : "",
                    'assets/images/speed_water.png'),
                //Typicons.water
              ],
            ),
          ),
          dataValueWidget(context, LocaleKeys.viloyat_titel.tr(),
              widget.info.region != -999 ? getRegion() : "", 5, 5),
          dataValueWidget(context, LocaleKeys.tuman_text.tr(),
              widget.info.region != -999 ? getDistrict() : "", 5, 5),
          dataValueWidget(
              context,
              LocaleKeys.paprvaka_title.tr(),
              widget.info.data != null
                  ? widget.info.data!.corec.toString()
                  : "",
              5,
              5),
          dataValueWidget(
              context,
              LocaleKeys.phonenumber_text.tr(),
              widget.info.simkart != null
                  ? widget.info.simkart!.toString()
                  : "",
              5,
              5),
          dataValueWidget(
              context,
              "Location:",
              widget.info.lat != null
                  ? widget.info.lat!.toString() +
                      "-" +
                      widget.info.lon!.toString()
                  : "",
              5,
              5),
          dataValueWidget(
              context,
              "IMEI:",
              widget.info.code != null ? widget.info.code!.toString() : "",
              5,
              5),
          dataValueWidget(
              context,
              LocaleKeys.vaqt_data_text_1.tr(),
              widget.info.data != null
                  ? timeString(widget.info.data!.time!)
                  : "",
              5,
              5),
          dataValueWidget(
              context,
              LocaleKeys.last_data_text.tr(),
              widget.info.data != null
                  ? "${daysBetween(dayString(widget.info.data!.time!.toString()), DateTime.now())} ${LocaleKeys.day_befor_text.tr()}"
                  : "",
              5,
              5),
        ],
      )),
    );
  }

  getRegion() {
    try {
      String region = widget.info.region.toString();

      if (region != "") {
        Region? region1 =
            regions.firstWhere((element) => element!.id == int.parse(region));
        return region1!.name;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getDistrict() {
    try {
      String district = widget.info.district.toString();

      if (district != "") {
        DistrictHttp? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.tum_nomi;
      } else {
        return "";
      }
    } catch (e) {
      return "$e";
    }
  }

  timeString(String time) {
    if (time.length == 12) {
      return "${time.substring(0, 4)}-${time.substring(4, 6)}-${time.substring(6, 8)} ${time.substring(8, 10)}:${time.substring(10, 12)}";
    }
  }

  dayString(String? time) {
    if (time!.length == 12) {
      return DateTime(int.parse(time.substring(0, 4)),
          int.parse(time.substring(4, 6)), int.parse(time.substring(6, 8)));
    }
  }

  Color colorLine(DateTime from) {
    int diffetnt = daysBetween(from, DateTime.now());
    if (diffetnt <= 1) {
      return Colors.blue;
    } else if (diffetnt > 1 && diffetnt <= 7) {
      return Colors.yellow;
    } else if (diffetnt > 7 && diffetnt <= 30) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
