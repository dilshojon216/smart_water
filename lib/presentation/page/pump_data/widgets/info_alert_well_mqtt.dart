import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import 'dashboard_mqtt_well.dart';
import 'last_mqtt_data_well.dart';

class InfoAlertWellMqtt extends StatefulWidget {
  List<WellMqttModel> waterMqttModels;
  InfoAlertWellMqtt({
    Key? key,
    required this.waterMqttModels,
  }) : super(key: key);

  @override
  State<InfoAlertWellMqtt> createState() => _InfoAlertWellMqttState();
}

class _InfoAlertWellMqttState extends State<InfoAlertWellMqtt> {
  int workingDevices = 0;
  int weekendDevices = 0;
  int monthDevices = 0;
  int noDataDevices = 0;
  int sdsd = 0;

  @override
  void initState() {
    getTotol();
    super.initState();
  }

  getTotol() {
    for (int i = 0; i < widget.waterMqttModels.length; i++) {
      var model = widget.waterMqttModels[i];
      setState(() {
        if (model.data != null && model.info != null) {
          int differnt = daysBetween(
              DateTime.parse(timeConvertMqtt(model.data!.t)), DateTime.now());
          if (differnt <= 1) {
            workingDevices++;
          } else if (differnt > 1 && differnt <= 7) {
            weekendDevices++;
          } else if (differnt > 7 && differnt <= 30) {
            monthDevices++;
          } else {
            sdsd++;
          }
        } else {
          noDataDevices++;
        }
      });
    }
    // 200/01/08,07:52:30+00
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
      return "2020-01-01 00:00";
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.info_alert_text_1.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${widget.waterMqttModels.length} ta ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.info_alert_text_2.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$workingDevices ta ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.info_alert_text_3.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$weekendDevices ta ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.info_alert_text_4.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$monthDevices ta ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.info_alert_text_5.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$sdsd ta ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    LocaleKeys.info_alert_text_6.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$noDataDevices ta ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.8, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboradMqttWell(
                                waterMqttModels: widget.waterMqttModels,
                              )));
                },
                child: Text(
                  LocaleKeys.more_btn_text.tr(),
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
