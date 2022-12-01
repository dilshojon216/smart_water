import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

import '../../../../core/other/status_bar.dart';
import 'on_loading.dart';

class ReadTableBlu extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;

  ReadTableBlu(
      {Key? key, required this.title, this.connection, this.subscription})
      : super(key: key);

  @override
  State<ReadTableBlu> createState() => _ReadTableBluState();
}

class _ReadTableBluState extends State<ReadTableBlu> {
  bool isReadData = false;
  List<String> dataTabel = [];
  int rowCount = 0;
  int columnCount = 10;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool get isConnected =>
      widget.connection != null && widget.connection!.isConnected;
  bool _connected = false;
  bool readBoolean = false;

  @override
  void dispose() {
    widget.subscription!.pause();
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
    startBluetooth();
    super.initState();
  }

  void readData() async {
    onLoading(context, "Yuklanmoqda...");
    dataTabel = [];
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      allowMultiple: false,
    );

    if (pickedFile != null) {
      if (pickedFile.files.first.path!.contains("table")) {
        var bytes = File(pickedFile.files.first.path!).readAsBytesSync();
        String str = utf8.decode(bytes);
        List<String> listData = str.split(",");
        print(listData.length);

        listData.forEach((element) {
          if (element.contains("#")) {
            num value = num.parse(element.replaceAll("#", ""));
            dataTabel.add((value / 1000.0).toStringAsFixed(3));
          } else {
            num value = num.parse(element);
            dataTabel.add((value / 1000.0).toStringAsFixed(3));
          }
        });

        setState(() {
          rowCount = dataTabel.length ~/ columnCount;
          if (dataTabel.length % columnCount != 0) {
            rowCount++;
            switch (dataTabel.length % columnCount) {
              case 1:
                for (int i = 0; i < 9; i++) {
                  dataTabel.add("");
                }
                break;
              case 2:
                for (int i = 0; i < 8; i++) {
                  dataTabel.add("");
                }
                break;
              case 3:
                for (int i = 0; i < 7; i++) {
                  dataTabel.add("");
                }

                break;
              case 4:
                for (int i = 0; i < 6; i++) {
                  dataTabel.add("");
                }

                break;
              case 5:
                for (int i = 0; i < 5; i++) {
                  dataTabel.add("");
                }

                break;
              case 6:
                for (int i = 0; i < 4; i++) {
                  dataTabel.add("");
                }

                break;
              case 7:
                for (int i = 0; i < 3; i++) {
                  dataTabel.add("");
                }

                break;
              case 8:
                for (int i = 0; i < 2; i++) {
                  dataTabel.add("");
                }

                break;
              case 9:
                dataTabel.add("");

                break;
            }
          }
          Navigator.pop(context);
          isReadData = true;
        });
      } else {
        Navigator.pop(context);
        show("Xatolik");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            visible: isReadData,
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_connected) {
                  setState(() {
                    isReadData = false;
                  });
                  _sendOnMessageToBluetooth();
                }
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: isReadData
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: LazyDataTable(
                rows: rowCount,
                columns: columnCount,
                tableDimensions: const LazyDataTableDimensions(
                  cellHeight: 50,
                  cellWidth: 100,
                  topHeaderHeight: 50,
                  leftHeaderWidth: 75,
                ),
                topHeaderBuilder: (i) => Center(
                    child: Text(
                  i.toString(),
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
                leftHeaderBuilder: (i) => Center(
                    child: Text(
                  "${i * 10}",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
                dataCellBuilder: (i, j) => Center(
                  child: Text(
                    dataTabel.length < i * 10 + j
                        ? ""
                        : dataTabel[(i * 10 + j)],
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                topLeftCornerWidget: Center(
                    child: Text(
                  "Q/N",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ),
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
    List<int> list = 'TABLE#'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection!.output.add(bytes);
    await widget.connection!.output.allSent;
    print('TABLE#');
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
}
