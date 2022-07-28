import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/other/status_bar.dart';
import 'last_mqtt_data_well.dart';

class NoDataMqttWell extends StatefulWidget {
  String title;
  List<WellMqttModel> waterMqttModels;
  NoDataMqttWell({
    Key? key,
    required this.title,
    required this.waterMqttModels,
  }) : super(key: key);

  @override
  State<NoDataMqttWell> createState() => _NoDataMqttWellState();
}

class _NoDataMqttWellState extends State<NoDataMqttWell> {
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
          widget.title,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: widget.waterMqttModels.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              widget.waterMqttModels[index].code,
              style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
