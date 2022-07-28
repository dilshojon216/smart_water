import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/other/status_bar.dart';
import 'card_wigdets.dart';
import 'new_setting.dart';
import 'update_setting.dart';

class SettingsScreen extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;
  SettingsScreen(
      {Key? key, required this.title, this.connection, this.subscription})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool get isConnected =>
      widget.connection != null && widget.connection!.isConnected;
  bool _connected = false;
  bool readBoolean = false;

  @override
  void dispose() {
    // widget.subscription!.pause();
    super.dispose();
  }

  void startBluetooth() {
    // initBluetooth();
    widget.subscription!.resume();
    _connected = widget.connection!.isConnected;
    if (_connected) {
      _connect();
    }
  }

  @override
  void initState() {
    //startBluetooth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Theme.of(context).primaryColor,
          iconSize: 20,
        ),
        systemOverlayStyle: statusBar(context),
        title: Text(
          widget.title,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                cardWidgets(
                  context,
                  "Sozlamalarni ko'rish",
                  Icons.settings_applications,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateSetting(
                          title: "Ma'lumotni o'qish",
                          connection: widget.connection,
                          subscription: widget.subscription,
                        ),
                      ),
                    );
                  },
                ),
                cardWidgets(
                  context,
                  "Yangi sozlamalar yozish",
                  Icons.open_in_new,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewSettingsFile(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int readConunt = 0;
  void _connect() async {
    //Future.delayed(Duration.zero, () => onLoading(context, "Reading data...."));
    if (_connected) {
      try {
        widget.subscription!.onData((data) {
          setState(() {
            if (utf8.decode(data) != "") {
              var messageList = utf8.decode(data).split("\r\n");
              for (var message in messageList) {
                if (message != "") {
                  if (message.contains("AOK#")) {
                    if (readConunt == 0) {
                      //Navigator.of(context).pop();
                      readConunt = 1;
                    }
                  }
                }
              }
            }
          });
        });
      } catch (e) {
        print(e.toString());
      }
      //  _sendOnMessageToBluetooth();
    }
  }

  void _sendOnMessageToBluetooth() async {
    List<int> list = 'TABLE#'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection!.output.add(bytes);
    await widget.connection!.output.allSent;
    print('TABLE#');
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
