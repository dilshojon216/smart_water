import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import '../../../../core/other/status_bar.dart';
import '../../../../data/model/water_data_month.dart';
import '../../../../data/model/water_data_ten_day.dart';
import '../../../../data/model/water_data_today.dart';
import '../../../../data/model/water_data_year.dart';
import '../../../../data/model/water_info.dart';
import '../../../cubit/seletion_water_cubit/selection_data_water_cubit.dart';
import '../../../cubit/water_all_data_cubit/water_all_data_cubit.dart';
import '../../../cubit/water_all_data_cubit/water_all_data_state.dart';
import 'ten_days_chart_water.dart';
import 'toyday_chart_water.dart';
import 'water_data_month.dart';
import 'water_data_tendays.dart';
import 'water_data_today.dart';
import 'water_data_year.dart';
import 'water_data_yesterday.dart';
import 'water_seletion_date.dart';
import 'year_chart_water.dart';

class WaterAllData extends StatefulWidget {
  final WaterInfo info;

  WaterAllData({Key? key, required this.info}) : super(key: key);

  @override
  State<WaterAllData> createState() => _WaterAllDataState();
}

class _WaterAllDataState extends State<WaterAllData>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        "KUNLIK",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Tab(
      child: Text(
        "KECHAGI",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Tab(
      child: Text(
        "10 KUNLIK",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Tab(
      child: Text(
        "YILLIK",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Tanlash",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ];

  TabController? _tabController;
  WaterDataToyday? _waterDataToday;
  WaterDataToyday? _waterDataYesterday;
  WaterDataTenDay? _waterDataTendays;
  WaterDataMonths? _waterDataMonth;
  WaterDatasYear? _waterDataYear;
  String? _errorWaterToday = "";
  String? _errorWaterYesterday;
  String? _errorWaterTendays;
  String? _errorWaterYear;

  bool _tanlashBool = true;
  bool internetConnection = false;
  int _selectedIndex = 0;

  late StreamSubscription subscription;
  late StreamSubscription subscription2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    intLas();
    String date =
        DateTime.now().toString().substring(0, 10).replaceAll("-", "");
    BlocProvider.of<WaterAllDataCubit>(context)
        .getWaterDataToday(widget.info.id.toString(), date);
    _tabController!.addListener(() {
      if (internetConnection) {
        _selectedIndex = _tabController!.index;
        _errorWaterToday = "";
        if (_tabController!.index == 0) {
          _tanlashBool = true;
          String date =
              DateTime.now().toString().substring(0, 10).replaceAll("-", "");
          BlocProvider.of<WaterAllDataCubit>(context)
              .getWaterDataToday(widget.info.id.toString(), date);
        } else if (_tabController!.index == 1) {
          _tanlashBool = true;
          var date1 = DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day - 1)
              .toString()
              .substring(0, 10)
              .replaceAll("-", "");
          BlocProvider.of<WaterAllDataCubit>(context)
              .getWaterDataYesterday(widget.info.id.toString(), date1);
        } else if (_tabController!.index == 2) {
          _tanlashBool = true;
          BlocProvider.of<WaterAllDataCubit>(context).getWaterDataTenDay(
            widget.info.id.toString(),
            DateTime.now().year.toString(),
          );
        } else if (_tabController!.index == 3) {
          _tanlashBool = true;
          BlocProvider.of<WaterAllDataCubit>(context).getWaterDataYear(
            widget.info.id.toString(),
            DateTime.now().year.toString(),
          );
        } else if (_tabController!.index == 4) {
          setState(() {
            _tanlashBool = false;
          });
        }
      }
      print(_tabController!.index);
    });
  }

  intLas() async {
    bool internetConnection1 = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetConnection = internetConnection1;
    });

    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hashInternet = status == InternetConnectionStatus.connected;
      setState(() {
        internetConnection = hashInternet;
      });
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
          "${widget.info.name}",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        actions: [
          Visibility(
            visible: _tanlashBool,
            child: IconButton(
              onPressed: () {
                if (_selectedIndex == 0 && _errorWaterToday == "") {
                  createExcelToday();
                } else if (_selectedIndex == 1 && _errorWaterToday == "") {
                  createExcelYeseteday();
                } else if (_selectedIndex == 2 && _errorWaterToday == "") {
                  createExcelTenDay();
                } else if (_selectedIndex == 3 && _errorWaterToday == "") {
                  createExcelYear();
                }
              },
              icon: const Icon(FontAwesome5.file_excel),
              color: Theme.of(context).primaryColor,
              iconSize: 25,
            ),
          ),
          Visibility(
            visible: _tanlashBool,
            child: IconButton(
              onPressed: () {
                if (_selectedIndex == 0 && _errorWaterToday == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodayChartWater(
                        data: _waterDataToday,
                        nameSensor: widget.info.name!,
                        error: _errorWaterToday,
                      ),
                    ),
                  );
                } else if (_selectedIndex == 1 && _errorWaterToday == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodayChartWater(
                        data: _waterDataYesterday,
                        nameSensor: widget.info.name!,
                        error: _errorWaterToday,
                      ),
                    ),
                  );
                } else if (_selectedIndex == 2 && _errorWaterToday == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TenDaysChartWater(
                        data: _waterDataTendays,
                        nameSensor: widget.info.name!,
                        error: _errorWaterToday,
                      ),
                    ),
                  );
                } else if (_selectedIndex == 3 && _errorWaterToday == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YearChartWater(
                        data: _waterDataYear,
                        nameSensor: widget.info.name!,
                        error: _errorWaterToday,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(FontAwesome.chart_line),
              color: Theme.of(context).primaryColor,
              iconSize: 25,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        bottom: TabBar(
          isScrollable: true,
          dragStartBehavior: DragStartBehavior.down,
          splashBorderRadius: BorderRadius.circular(10),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: myTabs,
          controller: _tabController,
        ),
      ),
      body: BlocListener<WaterAllDataCubit, WaterAllDataState>(
        listener: (context, state) {
          if (state is WaterDataTodayState) {
            setState(() {
              _waterDataToday = state.data;
            });
          } else if (state is WaterDataYesterdayState) {
            setState(() {
              _waterDataYesterday = state.data;
              print(_waterDataYesterday);
            });
          } else if (state is WaterDataTenDayState) {
            setState(() {
              _waterDataTendays = state.data;
            });
          } else if (state is WaterDataMonthState) {
            setState(() {
              _waterDataMonth = state.data;
            });
          } else if (state is WaterDataYearState) {
            setState(() {
              _waterDataYear = state.data;
            });
          } else if (state is WaterDataErrorState) {
            setState(() {
              _errorWaterToday = state.error;
            });
          }
        },
        child: TabBarView(children: [
          WaterDataToday(
              data: _waterDataToday,
              error: _errorWaterToday,
              internetConnection: internetConnection,
              nameSensor: widget.info.name!),
          WaterDataYesterday(
              dataToyday: _waterDataYesterday,
              error: _errorWaterToday,
              internetConnection: internetConnection),
          WaterDataTendays(
              data: _waterDataTendays,
              error: _errorWaterToday,
              internetConnection: internetConnection),
          WaterDataYear(
            data: _waterDataYear,
            error: _errorWaterToday,
            internetConnection: internetConnection,
          ),
          BlocProvider(
            create: (context) => SelectionDataWaterCubit(),
            child: WaterSeletionDate(
              info: widget.info,
              internetConnection: internetConnection,
            ),
          ),
        ], controller: _tabController),
      ),
    );
  }

  @override
  void dispose() {
    //  subscription.cancel();
    _tabController!.dispose();
    super.dispose();
  }

  Future<void> createExcelYear() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows = _buildCustomersDataRowsIHYear();
    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);

    sheet.importData(dataRows_1, 1, 1);
    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\Kunlik.xlsx'
        : '$path/${widget.info.name} Yillik.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIHYear() async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
    final Future<List<MqttdataYear>> reports = getDataListYear();

    List<MqttdataYear> reports_1 = await Future.value(reports);

    excelDataRows = reports_1.map<ExcelDataRow>((MqttdataYear dataRow) {
      return ExcelDataRow(cells: _daassYear(dataRow));
    }).toList();

    return excelDataRows;
  }

  Future<List<MqttdataYear>> getDataListYear() async {
    return _waterDataYear!.mqttdata;
  }

  List<ExcelDataCell> _daassYear(MqttdataYear dataRow) {
    return [
      ExcelDataCell(value: dataRow.time, columnHeader: "Vaqt"),
      ExcelDataCell(
          columnHeader: "Suv Sathi (m)",
          value: dataRow.level.toStringAsFixed(3)),
      ExcelDataCell(
          columnHeader: "Suv Sarifi (m3/s",
          value: dataRow.volume.toStringAsFixed(3)),
    ];
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
        : '$path/${widget.info.name}${DateTime.now().toString().substring(0, 10)}.xlsx';
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
    return _waterDataToday!.mqttdata;
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

  /// MqttdataYeseteday//
  Future<void> createExcelYeseteday() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIHYeseteday();
    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);

    sheet.importData(dataRows_1, 1, 1);
    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\Kunlik.xlsx'
        : '$path/${widget.info.name}${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1).toString().substring(0, 10)}.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIHYeseteday() async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
    final Future<List<MqttdataToyday>> reports = getDataListToday();

    List<MqttdataToyday> reports_1 = await Future.value(reports);

    excelDataRows = reports_1.map<ExcelDataRow>((MqttdataToyday dataRow) {
      return ExcelDataRow(cells: _daassYeseteday(dataRow));
    }).toList();

    return excelDataRows;
  }

  Future<List<MqttdataToyday>> getDataListYeseteday() async {
    return _waterDataToday!.mqttdata;
  }

  List<ExcelDataCell> _daassYeseteday(MqttdataToyday dataRow) {
    return [
      ExcelDataCell(value: dataRow.time, columnHeader: "Vaqt"),
      ExcelDataCell(
          columnHeader: "Suv Sathi (m)",
          value: dataRow.level!.toStringAsFixed(3)),
      ExcelDataCell(
          columnHeader: "Suv Sarifi (m3/s",
          value: dataRow.volume!.toStringAsFixed(3)),
    ];
  }

  ///MqttdataTenDay///

  Future<void> createExcelTenDay() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIHTenDay();
    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);

    sheet.importData(dataRows_1, 1, 1);
    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\Kunlik.xlsx'
        : '$path/${widget.info.name} Onkunlik.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIHTenDay() async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
    final Future<List<MqttdataTenDay>> reports = getDataListTenDay();

    List<MqttdataTenDay> reports_1 = await Future.value(reports);

    excelDataRows = reports_1.map<ExcelDataRow>((MqttdataTenDay dataRow) {
      return ExcelDataRow(cells: _daassTenDay(dataRow));
    }).toList();

    return excelDataRows;
  }

  Future<List<MqttdataTenDay>> getDataListTenDay() async {
    return _waterDataTendays!.mqttdata;
  }

  List<ExcelDataCell> _daassTenDay(MqttdataTenDay dataRow) {
    return [
      ExcelDataCell(value: dataRow.time, columnHeader: "Vaqt"),
      ExcelDataCell(
          columnHeader: "Suv Sathi (m)",
          value: dataRow.level.toStringAsFixed(3)),
      ExcelDataCell(
          columnHeader: "Suv Sarifi (m3/s",
          value: dataRow.volume!.toStringAsFixed(3)),
    ];
  }
}
