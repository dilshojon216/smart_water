import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../data/model/water_data_today.dart';
import 'no_data_error.dart';
import 'no_internet_widget.dart';

class WaterDataYesterday extends StatefulWidget {
  final WaterDataToyday? dataToyday;
  final String? error;
  bool internetConnection;
  WaterDataYesterday(
      {Key? key, this.dataToyday, this.error, required this.internetConnection})
      : super(key: key);

  @override
  State<WaterDataYesterday> createState() => _WaterDataYesterdayState();
}

class _WaterDataYesterdayState extends State<WaterDataYesterday> {
  List<MqttdataToyday> mqttdata = [];

  @override
  void initState() {
    super.initState();
    if (widget.dataToyday != null) {
      mqttdata = [];
      widget.dataToyday!.mqttdata.forEach((element) {
        String year = element.time.substring(0, 4);
        String month = element.time.substring(4, 6);
        String day = element.time.substring(6, 8);
        String hour = element.time.substring(8, 10);
        String minute = element.time.substring(10, 12);

        mqttdata.add(MqttdataToyday(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "$year-$month-$day $hour:$minute",
        ));
      });

      mqttdata.sort((a, b) => a.time.compareTo(b.time));
      mqttdata = mqttdata.reversed.toList();
      mqttdata.forEach((element) {
        element.time =
            "${element.time.substring(11, 13)}:${element.time.substring(14, 16)}";
      });
    }
  }

  @override
  void didUpdateWidget(covariant WaterDataYesterday oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataToyday != null) {
      mqttdata = [];
      widget.dataToyday!.mqttdata.forEach((element) {
        String year = element.time.substring(0, 4);
        String month = element.time.substring(4, 6);
        String day = element.time.substring(6, 8);
        String hour = element.time.substring(8, 10);
        String minute = element.time.substring(10, 12);

        mqttdata.add(MqttdataToyday(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "$year-$month-$day $hour:$minute",
        ));
      });

      mqttdata.sort((a, b) => a.time.compareTo(b.time));
      mqttdata = mqttdata.reversed.toList();
      mqttdata.forEach((element) {
        element.time =
            "${element.time.substring(11, 13)}:${element.time.substring(14, 16)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.internetConnection
        ? widget.dataToyday == null && widget.error == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : widget.error != ""
                ? noDataErrorWidget(widget.error)
                : widget.dataToyday == null
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
              LocaleKeys.vaqt_data_text_1.tr(),
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

  DataRow recentUserDataRow(MqttdataToyday userInfo, BuildContext context) {
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
          userInfo.level!.toStringAsFixed(3),
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
