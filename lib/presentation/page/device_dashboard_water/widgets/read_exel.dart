import 'dart:io';
import 'dart:isolate';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/other/status_bar.dart';
import 'on_loading.dart';

class ReadExel extends StatefulWidget {
  ReadExel({Key? key}) : super(key: key);

  @override
  State<ReadExel> createState() => _ReadExelState();
}

class _ReadExelState extends State<ReadExel> {
  bool isReadData = false;
  List<String> dataTabel = [];
  int rowCount = 0;
  int columnCount = 10;

  void readData() async {
    onLoading(context, "Yuklanmoqda...");

    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    if (pickedFile != null) {
      try {
        var bytes = File(pickedFile.files.first.path!).readAsBytesSync();

        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          dataTabel = [];
          for (int i = 1; i < excel.tables[table]!.maxRows; i++) {
            for (int j = 1; j < excel.tables[table]!.maxCols; j++) {
              if (excel.tables[table]!.rows[i][j] != null) {
                if (excel.tables[table]!.rows[i][j]!.value != null) {
                  num value = num.parse(
                      excel.tables[table]!.rows[i][j]!.value.toString());
                  dataTabel.add(value.toStringAsFixed(3));
                  //  print(excel.tables[table]!.rows[i][j]!.value);
                }
              }
            }
          }
        }
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
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Xatolik"),
            content: Text("Xatolik oldi!\n\n$e"),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "OK",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  shareData() {
    String dataText = "";
    for (var data in dataTabel) {
      if (data.isNotEmpty) {
        dataText += "${(num.parse(data) * 1000).toInt()},";
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

  void spawnIsolate(SendPort port) {
    port.send("Hello!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Exel faylda oraqli yozish",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
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
                setState(() {
                  isReadData = false;
                });
              },
            ),
          ),
          Visibility(
            visible: isReadData,
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
                dataCellBuilder: (i, j) => GestureDetector(
                  onSecondaryTap: () {},
                  onDoubleTap: () {
                    setState(() {});
                  },
                  child: Center(
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
}
