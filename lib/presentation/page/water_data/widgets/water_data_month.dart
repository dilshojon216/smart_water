import 'package:flutter/material.dart';

import 'package:smart_water/data/model/water_data_month.dart';

class WaterDataMonth extends StatefulWidget {
  final WaterDataMonths? data;
  final String? error;
  bool internetConnection;
  WaterDataMonth({
    Key? key,
    this.data,
    this.error,
    required this.internetConnection,
  }) : super(key: key);

  @override
  State<WaterDataMonth> createState() => _WaterDataMonthState();
}

class _WaterDataMonthState extends State<WaterDataMonth> {
  @override
  Widget build(BuildContext context) {
    return widget.error != null
        ? Container(child: Text(widget.error.toString()))
        : Container(
            child: Text(widget.data == null
                ? 'WaterDataMonth'
                : widget.data.toString()),
          );
  }
}
