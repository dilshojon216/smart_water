import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/model/water_data_ten_day.dart';

class TenDaysChartWater extends StatefulWidget {
  final WaterDataTenDay? data;
  final String nameSensor;
  final String? error;
  TenDaysChartWater({Key? key, this.data, required this.nameSensor, this.error})
      : super(key: key);

  @override
  State<TenDaysChartWater> createState() => _TenDaysChartWaterState();
}

class _TenDaysChartWaterState extends State<TenDaysChartWater> {
  List<MqttdataTenDay> mqttdata = [];
  double? maxValue = 0.0;
  bool changeValue = false;
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      mqttdata = [];
      for (var element in widget.data!.mqttdata) {
        if (changeValue) {
          maxValue = element.level;
        } else {
          maxValue = element.volume;
        }
        mqttdata.add(MqttdataTenDay(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "${getTime(element.time)}-${element.onkunlik} ",
          onkunlik: element.onkunlik,
        ));
      }
    }
  }

  @override
  void didUpdateWidget(covariant TenDaysChartWater oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != null) {
      mqttdata = [];
      widget.data!.mqttdata.forEach((element) {
        if (changeValue) {
          maxValue = element.level;
        } else {
          maxValue = element.volume;
        }
        mqttdata.add(MqttdataTenDay(
          stId: element.stId,
          level: element.level,
          volume: element.volume,
          time: "${getTime(element.time)}-${element.onkunlik}",
          onkunlik: element.onkunlik,
        ));
      });
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
          widget.nameSensor,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                changeValue = !changeValue;
              });
            },
            icon: const Icon(Icons.change_circle),
            color: Theme.of(context).primaryColor,
            iconSize: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2 * mqttdata.length,
          child: SfCartesianChart(
              // Enables the tooltip for all the series in chart
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryYAxis: NumericAxis(
                  labelFormat: changeValue ? '{value} m' : '{value} m3/s',
                  maximum: (maxValue! + 1)),

              // Initialize category axis
              legend: Legend(
                  isVisible: true,
                  iconHeight: 40,
                  iconWidth: 40,
                  position: LegendPosition.bottom,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  )),
              primaryXAxis: CategoryAxis(),
              series: dddassd()),
        ),
      ),
    );
  }

  List<ChartData> getDataChart() {
    List<ChartData> data = [];
    for (int i = 0; i < mqttdata.length; i++) {
      data.add(ChartData(mqttdata[i].time, mqttdata[i].volume));
    }
    return data;
  }

  List<ChartData> getDataChartLevel() {
    List<ChartData> data = [];
    for (int i = 0; i < mqttdata.length; i++) {
      data.add(ChartData(mqttdata[i].time, mqttdata[i].level));
    }
    return data;
  }

  List<ChartSeries> dddassd() {
    return [
      SplineSeries<ChartData, String>(
          name: LocaleKeys.year_chart_water_text_1.tr(),
          color: Theme.of(context).primaryColor,
          dataSource: changeValue ? getDataChartLevel() : getDataChart(),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            labelPosition: ChartDataLabelPosition.inside,
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
            shape: DataMarkerType.circle,
            borderWidth: 2,
            color: Colors.blue,
            borderColor: Colors.blue,
          ),
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y),
    ];
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final num? y;
}
