import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pump_viewmodel.dart';
import 'dashborad_mqtt_pump.dart';
import 'data_search.dart';
import 'info_alert_pump_mqtt.dart';
import 'last_data_pump.dart';

class AppBarWell extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  GlobalKey<ScaffoldState> key1;
  AppBarWell({
    Key? key,
    required this.title,
    required this.key1,
  }) : super(key: key);

  @override
  State<AppBarWell> createState() => _AppBarWellState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _AppBarWellState extends State<AppBarWell> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Theme.of(context).primaryColor,
          iconSize: 25),
      elevation: 2,
      actions: [
        IconButton(
            onPressed: () {
              int count = context.read<PumpViewModel>().subscribeCount;
              List<PumpMqttData> list =
                  context.read<PumpViewModel>().pumpMqttData;

              if (count == list.length) {
                showSearch(
                    context: context, delegate: DataSearch(pumpMqttData: list));
              } else {
                show("Ma'lumotlar to'liq o'qib bo'linmadi");
              }
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 25,
            )),
        IconButton(
            onPressed: () {
              int count = context.read<PumpViewModel>().subscribeCount;
              List<PumpMqttData> list =
                  context.read<PumpViewModel>().pumpMqttData;
              if (count == list.length) {
                showInfo(list);
              } else {
                show("Ma'lumotlar to'liq o'qib bo'linmadi");
              }
            },
            icon: Icon(
              Icons.info_outlined,
              color: Theme.of(context).primaryColor,
              size: 25,
            )),
        PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case '1':
                int count = context.read<PumpViewModel>().subscribeCount;
                List<PumpMqttData> list =
                    context.read<PumpViewModel>().pumpMqttData;
                if (count == list.length) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboradMqttPump(
                        pumpMqttData: list,
                      ),
                    ),
                  );
                } else {
                  show("Ma'lumotlar to'liq o'qib bo'linmadi");
                }
                break;
              case '2':
                clearData();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: '1',
              child: Text(
                "Ma'lumotlar tahlilli",
                style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            PopupMenuItem(
              value: '2',
              child: Text(
                'Chiqish',
                style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
          child: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
      title: Center(
        child: Text(
          widget.title,
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showInfo(List<PumpMqttData> post) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ma'lumotlar",
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: InfoAlertPumpMqtt(pumpMqttData: post),
            );
          },
        );
      },
    );
  }

  clearData() {
    context.read<PumpViewModel>().setInstall(false);
    context.read<PumpViewModel>().changePumpMqttData([], 0);
    context.read<PumpViewModel>().clearPumpStation();
  }
}
