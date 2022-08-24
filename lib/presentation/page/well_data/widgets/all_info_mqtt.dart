import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../device_dashboard_water/widgets/card_second_widget.dart';
import '../../device_dashboard_water/widgets/data_value_widget.dart';
import 'last_data_pump.dart';

class AllInfoMqttPump extends StatefulWidget {
  PumpMqttData post;
  AllInfoMqttPump({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<AllInfoMqttPump> createState() => _AllInfoMqttPumpState();
}

class _AllInfoMqttPumpState extends State<AllInfoMqttPump> {
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

  @override
  void initState() {
    super.initState();

    getAllDistase();
    getRgions();
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
          widget.post.stations.name,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
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
                      "Jami suv sarifi (m3):",
                      widget.post.positiveFlow!.toStringAsFixed(2),
                      'assets/images/water_level.png',
                      iconVisibility: false),
                  cardSecondWidget(
                      context,
                      "Musbat suv sarifi (m3):",
                      widget.post.tutoleFlow!.toStringAsFixed(2),
                      'assets/images/water_level.png',
                      iconVisibility: false),
                  //Typicons.water
                ],
              ),
            ),
            dataValueWidget(
                context, "Viloyat nomi:", getRegion().toString(), 5, 5),
            dataValueWidget(
                context, "Tashkilot nomi:", getDistrict().toString(), 5, 5),
            dataValueWidget(context, "Qurilmaning ID si:",
                widget.post.stations.topic, 5, 5),
            GestureDetector(
              onTap: () {
                goMaps(widget.post);
              },
              child: dataValueWidget(
                  context,
                  "Location:",
                  "${widget.post.stations.latitude}-${widget.post.stations.longitude}",
                  5,
                  7),
            ),
            dataValueWidget(context, "Info kelgan vaqti:",
                timeConvertMqtt(widget.post.time!), 5, 5),
          ],
        ),
      ),
    );
  }

  getRegion() {
    try {
      Region? region1 = regions.firstWhere(
          (element) => element!.id == widget.post.stations.regionId);
      return region1!.name;
    } catch (e) {
      return widget.post.stations.regionId;
    }
  }

  getDistrict() {
    try {
      Organization? district1 = districts.firstWhere(
          (element) => element!.id == widget.post.stations.balanceId);
      return district1!.name;
    } catch (e) {
      return widget.post.stations.balanceId;
    }
  }

  goMaps(PumpMqttData post) {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${post.stations.latitude},${post.stations.latitude}';
    launchUrl(Uri.parse(googleUrl));
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
      return "2020-01-01 00:00";
    }
  }
}
