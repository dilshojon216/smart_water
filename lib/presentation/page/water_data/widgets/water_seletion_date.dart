import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_water/presentation/page/water_data/widgets/toyday_chart_water.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

import '../../../../data/model/water_data_today.dart';
import '../../../../data/model/water_info.dart';
import '../../../cubit/seletion_water_cubit/selection_data_water_cubit.dart';
import '../../../cubit/seletion_water_cubit/selection_data_water_state.dart';
import 'no_data_error.dart';
import 'no_internet_widget.dart';

class WaterSeletionDate extends StatefulWidget {
  final WaterInfo info;
  bool internetConnection;
  WaterSeletionDate({
    Key? key,
    required this.info,
    required this.internetConnection,
  }) : super(key: key);

  @override
  State<WaterSeletionDate> createState() => _WaterSeletionDateState();
}

class _WaterSeletionDateState extends State<WaterSeletionDate> {
  String timeString = "";
  String error = "";
  List<MqttdataToyday> mqttdata = [];
  WaterDataToyday? data;
  @override
  void initState() {
    super.initState();
    timeString = DateTime.now().toString().substring(0, 10);
    if (widget.internetConnection) {
      BlocProvider.of<SelectionDataWaterCubit>(context).getWaterDataSelection(
          widget.info.id.toString(), timeString.replaceAll("-", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectionDataWaterCubit, SelectionDataWaterState>(
      listener: (context, state) {
        if (state is SelectionDataWaterLoadedState) {
          setState(() {
            data = state.data;
            if (data != null) {
              mqttdata = [];
              data!.mqttdata.forEach((element) {
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
          });
        } else if (state is SelectionDataWaterErrorState) {
          setState(() {
            error = state.error;
          });
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextButton(
                    onPressed: () {
                      _selectionDay();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          timeString,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      if (error == "" && widget.internetConnection) {
                        createExcelToday();
                      }
                    },
                    icon: const Icon(FontAwesome5.file_excel),
                    color: Theme.of(context).primaryColor,
                    iconSize: 25,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      if (error == "" && widget.internetConnection) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodayChartWater(
                              data: data,
                              nameSensor: widget.info.name!,
                              error: error,
                              dateString: timeString,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(FontAwesome5.chart_line),
                    color: Theme.of(context).primaryColor,
                    iconSize: 25,
                  ),
                ),
              ],
            ),
            widget.internetConnection
                ? data == null && error == ""
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : error != ""
                        ? noDataErrorWidget(error)
                        : data == null || mqttdata.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _dataList()
                : noInternetWidget()
          ],
        ),
      ),
    );
  }

  _dataList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DataTable(
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        columns: [
          DataColumn(
            label: Text(
              LocaleKeys.vaqt_data_text_1.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              LocaleKeys.suv_sathi_data_text_2.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              LocaleKeys.suv_sarfi_data_text.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
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
          userInfo.level!.toStringAsFixed(3),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        )),
        DataCell(
          Text(
            userInfo.volume!.toStringAsFixed(3),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  DateTime selectedDate = DateTime.now();
  void _selectionDay() async {
    var dataTime = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    setState(() {
      if (dataTime != null) {
        selectedDate = dataTime;
        timeString = selectedDate.toString().substring(0, 10);
        if (widget.internetConnection) {
          mqttdata = [];
          error = "";
          BlocProvider.of<SelectionDataWaterCubit>(context)
              .getWaterDataSelection(
                  widget.info.id.toString(), timeString.replaceAll("-", ""));
        }
      }
    });
  }

  Future<void> createExcelToday() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIHToday();
    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);

    sheet.importData(dataRows_1, 1, 1);
    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\Kunlik.xlsx'
        : '$path/${widget.info.name} ${timeString}.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIHToday() async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
    final Future<List<MqttdataToyday>> reports = getDataListToday();

    List<MqttdataToyday> reports_1 = await Future.value(reports);

    excelDataRows = reports_1.map<ExcelDataRow>((MqttdataToyday dataRow) {
      return ExcelDataRow(cells: _daassToday(dataRow));
    }).toList();

    return excelDataRows;
  }

  Future<List<MqttdataToyday>> getDataListToday() async {
    return data!.mqttdata;
  }

  List<ExcelDataCell> _daassToday(MqttdataToyday dataRow) {
    return [
      ExcelDataCell(
          value: dataRow.time, columnHeader: LocaleKeys.vaqt_data_text_1.tr()),
      ExcelDataCell(
          columnHeader: LocaleKeys.suv_sathi_data_text_2.tr(),
          value: dataRow.level!.toStringAsFixed(3)),
      ExcelDataCell(
          columnHeader: LocaleKeys.suv_sarfi_data_text.tr(),
          value: dataRow.volume!.toStringAsFixed(3)),
    ];
  }
}
