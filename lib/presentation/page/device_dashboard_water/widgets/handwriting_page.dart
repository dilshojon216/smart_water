import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_water/presentation/page/device_dashboard_water/widgets/on_loading.dart';

import '../../../../core/other/status_bar.dart';

class HandWritingPage extends StatefulWidget {
  HandWritingPage({Key? key}) : super(key: key);

  @override
  State<HandWritingPage> createState() => _HandWritingPageState();
}

class _HandWritingPageState extends State<HandWritingPage> {
  final TextEditingController _textController = TextEditingController();
  final List<TextEditingController> _textControllers = [];

  bool isWriting = false;
  List<String> dataTabel = [];
  int rowCount = 0;
  int columnCount = 10;
  int lengthTabless = 0;
  makeTable() {
    int lengthTable = int.parse(_textController.text);
    lengthTabless = lengthTable;
    for (int i = 0; i <= lengthTable; i++) {
      dataTabel.add("");
      _textControllers.add(TextEditingController());
    }

    setState(() {
      rowCount = dataTabel.length ~/ columnCount;
      if (dataTabel.length % columnCount != 0) {
        rowCount++;
        switch (dataTabel.length % columnCount) {
          case 1:
            for (int i = 0; i < 9; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }
            break;
          case 2:
            for (int i = 0; i < 8; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }
            break;
          case 3:
            for (int i = 0; i < 7; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }

            break;
          case 4:
            for (int i = 0; i < 6; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }

            break;
          case 5:
            for (int i = 0; i < 5; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }

            break;
          case 6:
            for (int i = 0; i < 4; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }

            break;
          case 7:
            for (int i = 0; i < 3; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }

            break;
          case 8:
            for (int i = 0; i < 2; i++) {
              dataTabel.add("");
              _textControllers.add(TextEditingController());
            }

            break;
          case 9:
            dataTabel.add("");
            _textControllers.add(TextEditingController());
            break;
        }
      }

      isWriting = true;
    });
    Navigator.pop(context);
  }

  shareData() {
    String dataText = "";
    for (int i = 0; i < dataTabel.length; i++) {
      if (dataTabel[i] == "") {
        if (i < lengthTabless) {
          dataText += "-1000,";
        }
      } else {
        dataText += "${(num.parse(dataTabel[i]) * 1000).toInt()},";
      }
    }
    dataText = "${dataText.substring(0, dataText.length - 1)}#";
    print(dataText);
    share(dataText);
  }

  void share(String data) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.request().isGranted) {
      try {
        var testFile = await writeData(data);
        await Share.shareFilesWithResult([testFile.absolute.path]);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> get localPath async {
    final directory =
        await getApplicationDocumentsDirectory(); //home/directory:text
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;

    return File("$path/table.txt");
  }

//Write and read from our file
  Future<File> writeData(String message) async {
    final file = await _localFile;

    return file.writeAsString("$message");
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
          "Jadvalni to'ldirish",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        actions: [
          Visibility(
            visible: isWriting,
            child: IconButton(
              icon: Icon(
                Icons.replay,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  dataTabel.clear();
                  isWriting = false;
                  _textController.text = "";
                });
              },
            ),
          ),
          Visibility(
            visible: isWriting,
            child: IconButton(
              icon: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                shareData();
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: isWriting
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
                    child: TextField(
                  controller: _textControllers[i * columnCount + j],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    dataTabel[i * columnCount + j] = value;
                    print(dataTabel.toString());
                  },
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                )),
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
          : Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Jadval uzunligini kiriting (sm):",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Qiymatni kiriting...",
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.8, 60)),
                        onPressed: () {
                          setState(() {
                            if (_textController.text != "") {
                              onLoading(context, "Make table...");
                              makeTable();
                            }
                          });
                        },
                        child: Text(
                          "Jadvalni yasash ",
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
