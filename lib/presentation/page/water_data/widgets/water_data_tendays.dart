import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../data/model/water_data_ten_day.dart';
import 'no_data_error.dart';
import 'no_internet_widget.dart';

class WaterDataTendays extends StatefulWidget {
  final WaterDataTenDay? data;
  final String? error;
  bool internetConnection;
  WaterDataTendays({
    Key? key,
    this.data,
    this.error,
    required this.internetConnection,
  }) : super(key: key);

  @override
  State<WaterDataTendays> createState() => _WaterDataTendaysState();
}

class _WaterDataTendaysState extends State<WaterDataTendays> {
  List<MqttdataTenDay> mqttdata = [];

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      mqttdata = [];
      widget.data!.mqttdata.forEach((element) {
        mqttdata.add(MqttdataTenDay(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "${getTime(element.time)}-${element.onkunlik} ",
          onkunlik: element.onkunlik,
        ));
      });

      // mqttdata.sort((a, b) => a.time.compareTo(b.time));
      // mqttdata = mqttdata.reversed.toList();
      // // mqttdata.forEach((element) {
      // //   element.time =
      // //       "${element.time.substring(11, 13)}:${element.time.substring(14, 16)}";
      // // });
    }
  }

  @override
  void didUpdateWidget(covariant WaterDataTendays oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != null) {
      mqttdata = [];
      widget.data!.mqttdata.forEach((element) {
        mqttdata.add(MqttdataTenDay(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "${getTime(element.time)}-${element.onkunlik}",
          onkunlik: element.onkunlik,
        ));
      });

      // mqttdata.sort((a, b) => a.time.compareTo(b.time));
      // mqttdata = mqttdata.reversed.toList();
      // mqttdata.forEach((element) {
      //   element.time =
      //       "${element.time.substring(11, 13)}:${element.time.substring(14, 16)}";
      // });
    }
  }

  String getTime(String time) {
    String asss = time.substring(time.length - 2, time.length);
    switch (asss) {
      case "01":
        return "Yanvar";
      case "02":
        return "Fevral";
      case "03":
        return "Mart";
      case "04":
        return "Aprel";
      case "05":
        return "May";
      case "06":
        return "Iyun";
      case "07":
        return "Iyul";
      case "08":
        return "Avgust";
      case "09":
        return "Sentyabr";
      case "10":
        return "Oktyabr";
      case "11":
        return "Noyabr";
      case "12":
        return "Dekabr";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.internetConnection
        ? widget.data == null && widget.error == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : widget.error != ""
                ? noDataErrorWidget(widget.error)
                : widget.data == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _dataList()
        : noInternetWidget();
  }

  _dataList() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        horizontalMargin: 15,
        columnSpacing: 50,
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        columns: [
          DataColumn(
            label: Text(
              LocaleKeys.ten_days_text.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              LocaleKeys.suv_sathi_data_text_2.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              LocaleKeys.suv_sarfi_data_text.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ],
        rows: List.generate(
          mqttdata.length,
          (index) => recentUserDataRow(mqttdata[index], context),
        ),
      ),
    );
  }

  DataRow recentUserDataRow(MqttdataTenDay userInfo, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  userInfo.time,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(
          userInfo.level.toStringAsFixed(3),
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        )),
        DataCell(
          Text(
            userInfo.volume!.toStringAsFixed(3),
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
