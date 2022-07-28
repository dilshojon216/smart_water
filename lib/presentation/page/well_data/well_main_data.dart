
import 'package:flutter/material.dart';

import 'widgets/appbar_page.dart';

class WellMainData extends StatefulWidget {
  final String title;
  const WellMainData({Key? key, required this.title}) : super(key: key);

  @override
  State<WellMainData> createState() => _WellMainDataState();
}

class _WellMainDataState extends State<WellMainData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar:AppBarWell(title:widget.title) ,
      body: Center(child: Text("well data"),),
    );
  }
}
