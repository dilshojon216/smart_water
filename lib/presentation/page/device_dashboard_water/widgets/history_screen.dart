import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/other/status_bar.dart';
import 'on_loading.dart';

class HistoryScreen extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;
  HistoryScreen(
      {Key? key, required this.title, this.connection, this.subscription})
      : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool readBoolean = false;
  List<String> dataTabel = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool get isConnected =>
      widget.connection != null && widget.connection!.isConnected;
  bool _connected = false;
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
    super.initState();
    startBluetooth();
  }

  @override
  void dispose() {
    widget.subscription!.pause();
    super.dispose();
  }

  void readData() async {
    onLoading(context, "Yuklanmoqda...");

    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      allowMultiple: false,
    );

    if (pickedFile != null) {
      if (pickedFile.files.first.path!.contains("log")) {
        var bytes = await File(pickedFile.files.first.path!).readAsBytes();
        String str = utf8.decode(bytes);
        var lines = str.split("\n");

        dataTabel = lines;
        dataTabel.removeLast();
        print(str);

        setState(() {
          readBoolean = true;
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    }
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
        actions: [
          Visibility(
            visible: readBoolean,
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_connected) {
                  setState(() {
                    readBoolean = false;
                  });
                  _sendOnMessageToBluetooth();
                }
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: readBoolean
          ? ListView.builder(
              itemCount: dataTabel.length,
              itemBuilder: (context, index) {
                return _post(dataTabel[index], context);
              },
            )
          : Center(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 80)),
                  onPressed: () async {
                    readData();
                  },
                  child: Text(
                    "Ma'lumotni o'qish ",
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _post(String post, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(5.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      "Suv sathi:",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      getSath(post),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      "Suv sarfi:",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      getSarif(post),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      "Vaqti:",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      getTime(post),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

// {"D":{"T":"22/07/13,06:12:16+00","H":"-0010","Q":"-00001000","C":"000","S":" "}}
  getSarif(String a) {
    try {
      if (a.contains("Q")) {
        var sd = a.split(",");
        var s = sd[3].substring(4).replaceAll("\"", "");
        double d = int.parse(s) / 1000.0;
        return "${d.toStringAsFixed(2)} m3/s";
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getTime(String a) {
    try {
      if (a.contains("T")) {
        var sd = a.split(",");
        var s1 = sd[0].substring(11);
        var s2 = sd[1].replaceAll("\"", "").substring(0, 5);
        return "$s1,$s2";
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSath(String a) {
    try {
      if (a.contains("H")) {
        var sd = a.split(",");
        var s = sd[2].substring(4).replaceAll("\"", "");
        double d = int.parse(s) / 10.0;
        return "${d.toStringAsFixed(2)} m3/s";
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  int readConunt = 0;
  void _connect() async {
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
                      Navigator.of(context).pop();
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
      _sendOnMessageToBluetooth();
    }
  }

  void _sendOnMessageToBluetooth() async {
    Future.delayed(Duration.zero, () => onLoading(context, "Reading data...."));
    readConunt = 0;
    List<int> list = 'HISTORY#'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection!.output.add(bytes);
    await widget.connection!.output.allSent;
    print('HISTORY#');
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
