import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/other/status_bar.dart';

import 'card_wigdets.dart';

import 'read_tabel_blu.dart';
import 'write_selection_page.dart';

class TableScreen extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;
  TableScreen(
      {Key? key, required this.title, this.connection, this.subscription})
      : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
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
    // startBluetooth();
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
                  "Ma'lumotni o'qish",
                  Icons.file_download,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadTableBlu(
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
                  "Yangi ma'lumot yozish",
                  Icons.file_upload,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriteSelectionPage(),
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

  show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
