import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../translations/locale_keys.g.dart';
import 'last_data_pump.dart';
import 'more_data_mqtt_pump.dart';

class DashboradMqttPump extends StatefulWidget {
  List<PumpMqttData> pumpMqttData;
  DashboradMqttPump({
    Key? key,
    required this.pumpMqttData,
  }) : super(key: key);

  @override
  State<DashboradMqttPump> createState() => _DashboradMqttPumpState();
}

class _DashboradMqttPumpState extends State<DashboradMqttPump> {
  int workingDevices = 0;
  int weekendDevices = 0;
  int monthDevices = 0;
  int noDataDevices = 0;
  int sdsd = 0;
  List<PumpMqttData> workingList = [];
  List<PumpMqttData> weekendList = [];
  List<PumpMqttData> monthList = [];
  List<PumpMqttData> longTimeworkingList = [];
  List<PumpMqttData> noworkingList = [];
  Map<String, double> dataMap = {};

  @override
  void initState() {
    getTotol();
    super.initState();
  }

  getTotol() {
    List<PumpMqttData> workingList1 = [];
    List<PumpMqttData> weekendList1 = [];
    List<PumpMqttData> monthList1 = [];
    List<PumpMqttData> longTimeworkingList1 = [];
    List<PumpMqttData> noworkingList1 = [];
    for (int i = 0; i < widget.pumpMqttData.length; i++) {
      var model = widget.pumpMqttData[i];

      if (model.positiveFlow != null && model.tutoleFlow != null) {
        int differnt = daysBetween(
            DateTime.parse(timeConvertMqtt(model.time!)), DateTime.now());
        if (differnt <= 1) {
          workingDevices++;
          workingList1.add(model);
        } else if (differnt > 1 && differnt <= 7) {
          weekendDevices++;
          weekendList1.add(model);
        } else if (differnt > 7 && differnt <= 30) {
          monthDevices++;
          monthList1.add(model);
        } else {
          sdsd++;
          longTimeworkingList1.add(model);
        }
      } else {
        noDataDevices++;
        noworkingList1.add(model);
      }
    }

    setState(() {
      int totulor = widget.pumpMqttData.length;
      dataMap = {
        '${LocaleKeys.dashboard_mqtt_text_1.tr()} ': workingDevices.toDouble(),
        '${LocaleKeys.dashboard_mqtt_text_2.tr()} ': weekendDevices.toDouble(),
        '${LocaleKeys.dashboard_mqtt_text_3.tr()} ': monthDevices.toDouble(),
        '${LocaleKeys.dashboard_mqtt_text_4.tr()} ': monthDevices.toDouble(),
        '${LocaleKeys.dashboard_mqtt_text_5.tr()} ': noDataDevices.toDouble(),
      };
      workingList = workingList1;
      weekendList = weekendList1;
      monthList = monthList1;
      longTimeworkingList = longTimeworkingList1;
      noworkingList = noworkingList1;
    });
    // 200/01/08,07:52:30+00
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
      return "";
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  var colorList = [
    Colors.green,
    Colors.orangeAccent,
    Colors.brown,
    Colors.red,
    Colors.black,
  ];

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
          LocaleKeys.water_data_text_2.tr(),
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        LocaleKeys.dashboard_mqtt_text_6.tr(),
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 50,
                        chartRadius: MediaQuery.of(context).size.width / 2,
                        colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 50,
                        centerText: "${widget.pumpMqttData.length} ta",
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      LocaleKeys.dashboard_mqtt_text_1.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[0],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoreDataMqttPump(
                                        title: LocaleKeys.dashboard_mqtt_text_1
                                            .tr(),
                                        pumpMqttData: workingList,
                                      )));
                        },
                        child: Text(
                          LocaleKeys.more_btn_text.tr(),
                          style: GoogleFonts.roboto(
                            color: colorList[0],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                horizontalMargin: 20,
                columns: listColumn(colorList[0]),
                rows: List.generate(
                  workingList.take(5).toList().length,
                  (index) => listRow(
                    workingList[index],
                    context,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      LocaleKeys.dashboard_mqtt_text_2.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[1],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoreDataMqttPump(
                                        title: LocaleKeys.dashboard_mqtt_text_2
                                            .tr(),
                                        pumpMqttData: weekendList,
                                      )));
                        },
                        child: Text(
                          LocaleKeys.more_btn_text.tr(),
                          style: GoogleFonts.roboto(
                            color: colorList[1],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                horizontalMargin: 20,
                columns: listColumn(colorList[1]),
                rows: List.generate(
                  weekendList.take(5).toList().length,
                  (index) => listRow(
                    weekendList[index],
                    context,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      LocaleKeys.dashboard_mqtt_text_3.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[2],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoreDataMqttPump(
                                    title:
                                        LocaleKeys.dashboard_mqtt_text_3.tr(),
                                    pumpMqttData: monthList,
                                  )));
                    },
                    child: Text(
                      LocaleKeys.more_btn_text.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[2],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                horizontalMargin: 20,
                columns: listColumn(colorList[2]),
                rows: List.generate(
                  monthList.take(5).toList().length,
                  (index) => listRow(
                    monthList[index],
                    context,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      LocaleKeys.dashboard_mqtt_text_4.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[3],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoreDataMqttPump(
                                    title:
                                        LocaleKeys.dashboard_mqtt_text_4.tr(),
                                    pumpMqttData: longTimeworkingList,
                                  )));
                    },
                    child: Text(
                      LocaleKeys.more_btn_text.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[3],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                horizontalMargin: 20,
                columns: listColumn(colorList[3]),
                rows: List.generate(
                  longTimeworkingList.take(5).toList().length,
                  (index) => listRow(
                    longTimeworkingList[index],
                    context,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      LocaleKeys.dashboard_mqtt_text_5.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[4],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {},
                    child: Text(
                      LocaleKeys.more_btn_text.tr(),
                      style: GoogleFonts.roboto(
                        color: colorList[4],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                horizontalMargin: 20,
                columns: listColumn(colorList[4]),
                rows: List.generate(
                  noworkingList.take(5).toList().length,
                  (index) => listRow(
                    noworkingList[index],
                    context,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> listColumn(Color color) {
    return [
      DataColumn(
        label: Text(
          LocaleKeys.dashboard_mqtt_text_7.tr(),
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          LocaleKeys.dashboard_mqtt_text_8.tr(),
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    ];
  }

  DataRow listRow(PumpMqttData model, BuildContext context) {
    return DataRow(cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            model.stations.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            model.time != null ? timeConvertMqtt(model.time!) : "Ma'lumot yo'q",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ]);
  }
}
