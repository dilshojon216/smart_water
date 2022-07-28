
import 'package:flutter/material.dart';

import 'widgets/app_bar_calc.dart';

class WaterFlowCalc extends StatefulWidget {
  final String title;
  const WaterFlowCalc({Key? key, required this.title}) : super(key: key);

  @override
  State<WaterFlowCalc> createState() => _WaterFlowCalcState();
}

class _WaterFlowCalcState extends State<WaterFlowCalc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWaterFlowCalc(title:widget.title),
      body: Center(child: Text("device settings"),),
    );
  }
}
