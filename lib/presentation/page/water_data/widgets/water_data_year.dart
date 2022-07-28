import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/model/water_data_year.dart';
import '../../../../translations/locale_keys.g.dart';
import 'no_data_error.dart';
import 'no_internet_widget.dart';

class WaterDataYear extends StatefulWidget {
  final WaterDatasYear? data;
  final String? error;
  bool internetConnection;
  WaterDataYear({
    Key? key,
    this.data,
    this.error,
    required this.internetConnection,
  }) : super(key: key);

  @override
  State<WaterDataYear> createState() => _WaterDataYearState();
}

class _WaterDataYearState extends State<WaterDataYear> {
  List<MqttdataYear> mqttdata = [];

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      mqttdata = [];
      widget.data!.mqttdata.forEach((element) {
        mqttdata.add(MqttdataYear(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "${element.time}-${LocaleKeys.yil_title.tr()}",
        ));
      });
    }
  }

  @override
  void didUpdateWidget(covariant WaterDataYear oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != null) {
      mqttdata = [];
      widget.data!.mqttdata.forEach((element) {
        mqttdata.add(MqttdataYear(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "${element.time}-${LocaleKeys.yil_title.tr()}",
        ));
      });
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
              LocaleKeys.yillar_text.tr(),
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

  DataRow recentUserDataRow(MqttdataYear userInfo, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  userInfo.time,
                  style: GoogleFonts.poppins(
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
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        )),
        DataCell(
          Text(
            userInfo.volume.toStringAsFixed(3),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
