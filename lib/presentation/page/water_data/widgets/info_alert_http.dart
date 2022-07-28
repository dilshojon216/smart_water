import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:smart_water/data/model/water_info.dart';

import 'dashbord_http_water.dart';

class InfoAlertHttp extends StatefulWidget {
  List<WaterInfo> waterHttpsModels;
  InfoAlertHttp({
    Key? key,
    required this.waterHttpsModels,
  }) : super(key: key);

  @override
  State<InfoAlertHttp> createState() => _InfoAlertHttpState();
}

class _InfoAlertHttpState extends State<InfoAlertHttp> {
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
    for (int i = 0; i < widget.waterHttpsModels.length; i++) {
      var model = widget.waterHttpsModels[i];
      setState(() {
        if (model.data != null && model.data!.id != -999) {
          int differnt = daysBetween(
              DateTime.parse(timeString(model.data!.time!)), DateTime.now());
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
                    "Jami qurilmlar soni:",
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
                    '${widget.waterHttpsModels.length} ta ',
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
                    "Bugun ishlagan qurilmalar soni:",
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
                    "Bir hafta oraliqda ishlagan qurilmalar soni:",
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
                    "Bir oy oraliqda ishlagan qurilmalar soni:",
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
                    "Uzoq muddat oldin ishlagan qurilmalar soni:",
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
                    "Umuman ishlamagn qurilmalar soni:",
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
                          builder: (context) => DashbordHttpWater(
                                waterInfoList: widget.waterHttpsModels,
                              )));
                },
                child: Text(
                  "Batafsil ma'lumot",
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

  timeString(String time) {
    if (time.length == 12) {
      return "${time.substring(0, 4)}-${time.substring(4, 6)}-${time.substring(6, 8)} ${time.substring(8, 10)}:${time.substring(10, 12)}";
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
