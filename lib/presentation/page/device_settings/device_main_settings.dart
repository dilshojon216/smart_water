import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/presentation/routes/app_routes.dart';

import 'widgets/app_bar_page.dart';
import 'widgets/device_card.dart';

class DeviceMainSettings extends StatefulWidget {
  final String title;
  const DeviceMainSettings({Key? key, required this.title}) : super(key: key);

  @override
  State<DeviceMainSettings> createState() => _DeviceMainSettingsState();
}

class _DeviceMainSettingsState extends State<DeviceMainSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarDeviceSettings(title: widget.title),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              "Kerakli qurilmani tanlang",
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                cardDevices(
                  "Smart Water",
                  "assets/images/smart_water.png",
                  context,
                  () {
                    Navigator.of(context).pushNamed(
                        AppRoutesNames.deviceSettingsWater,
                        arguments: "water");
                  },
                ),
                cardDevices(
                  "Smart Well",
                  "assets/images/smart_well.png",
                  context,
                  () {
                    Navigator.of(context).pushNamed(
                        AppRoutesNames.deviceSettingsWater,
                        arguments: "well");
                  },
                ),
                cardDevices("Flow meter", "assets/images/flow_meter.png",
                    context, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
