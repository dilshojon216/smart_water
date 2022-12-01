import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_water/core/other/constants.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../../../data/model/sensor_type.dart';
import 'data_value_widget.dart';
import 'district_value_widget.dart';
import 'drop_dwan_value_widget.dart';
import 'on_loading.dart';
import 'region_value_widget.dart';
import 'sensor_type_value_widget.dart';
import 'setting_valeu_widget.dart';

class UpdateSetting extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;
  UpdateSetting(
      {Key? key, required this.title, this.connection, this.subscription})
      : super(key: key);

  @override
  State<UpdateSetting> createState() => _UpdateSettingState();
}

class _UpdateSettingState extends State<UpdateSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool get isConnected =>
      widget.connection != null && widget.connection!.isConnected;
  bool _connected = false;
  bool readBoolean = false;
  List<String> dataConfig = [];
  List<Region?> regions = [];
  List<Organization?> districts = [];
  List<Organization?> districts2 = [];
  List<SensorType?> sensorType = [];
  bool sending = false;
  bool isWrite = false;
  Region? seletionRegions;
  Organization? selectionDistricts;
  SensorType? selectionSensorType;
  int? selectionConrrection;
  int? selectionMenusePeriod;
  int? selectionSendPeriod;
  int regionId = 0;
  bool oldconfig = false;
  final TextEditingController _nameladerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _correctionController = TextEditingController();
  final TextEditingController _menusePeriodContoller = TextEditingController();
  final TextEditingController _sendPeriodContoller = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    widget.subscription!.pause();
    super.dispose();
  }

  geSensorType() async {
    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();

    final dao = database.sensorTypeDao;
    final result = await dao.getAll();

    setState(() {
      sensorType = result;
    });
  }

  getRgions() async {
    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();

    final dao = database.regionDao;
    final result = await dao.getAll();

    setState(() {
      regions = result;
    });
  }

  int coutSletion = 0;
  getDistricts() async {
    if (coutSletion == 0) {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/json/balans_tashkilotlar.json");

      final jsonResult = json.decode(data);
      List<Organization> lastHoursDataModels = List<Organization>.from(
          jsonResult.map((element) => Organization.fromJson(element)));
      districts = lastHoursDataModels;
      coutSletion = 1;
    }

    setState(() {
      districts2 = districts
          .where((element) => element!.regionId == seletionRegions!.id)
          .toList();
      selectionDistricts = districts2[0];
      print(selectionDistricts);
    });
  }

  getAllDistase() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/balans_tashkilotlar.json");

    final jsonResult = json.decode(data);
    List<Organization> lastHoursDataModels = List<Organization>.from(
        jsonResult.map((element) => Organization.fromJson(element)));

    setState(() {
      districts = lastHoursDataModels;
    });
    print(jsonResult);
  }

  void readData() async {
    onLoading(context, "Yuklanmoqda...");
    dataConfig = [];
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      allowMultiple: false,
    );

    if (pickedFile != null) {
      if (pickedFile.files.first.path!.contains("config")) {
        var bytes = File(pickedFile.files.first.path!).readAsBytesSync();
        String str = utf8.decode(bytes);

        setState(() {
          dataConfig = str.split("\n");
          readBoolean = true;
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        show("Xatolik");
      }
    }
  }

  typeCheked() {
    if (_nameladerController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _correctionController.text.isNotEmpty &&
        _menusePeriodContoller.text.isNotEmpty &&
        _sendPeriodContoller.text.isNotEmpty &&
        seletionRegions != null &&
        selectionDistricts != null &&
        selectionSensorType != null) {
      setState(() {
        sending = true;
      });
    } else {
      setState(() {
        sending = false;
      });
    }
  }

  makeDataSend() {
    String dataToSend =
        "UPNUM=${_phoneController.text}#\nSENSOR=${selectionSensorType!.name},0,$selectionConrrection#\nDAQ=10,60,2,$selectionMenusePeriod#\nMQTT=185.196.214.190,1883,emqx,12345,1,0,60,60,SARF,SATH,BAT,COR#\nFTP=185.196.214.63,21,admin_smart_ftp,12345678,$selectionSendPeriod,BAT,FW#\nNAME1=${seletionRegions!.id}#\nNAME2=${selectionDistricts!.id}#\nNAME3=${_nameladerController.text}#";
    share(dataToSend);
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

  Future<File> writeData(String message) async {
    final file = await _localFile;

    return file.writeAsString("$message");
  }

  Future<String> get localPath async {
    final directory =
        await getApplicationDocumentsDirectory(); //home/directory:text
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;

    return File("$path/config.txt");
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
    getRgions();
    geSensorType();
    getAllDistase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        actions: [
          Visibility(
            visible: readBoolean,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isWrite = true;
                  readBoolean = false;
                });
              },
              icon: Icon(
                Icons.create,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Visibility(
            visible: readBoolean || isWrite,
            child: IconButton(
              onPressed: () {
                setState(() {
                  readBoolean = false;
                  isWrite = false;
                  _sendOnMessageToBluetooth();
                });
              },
              icon: Icon(
                Icons.replay,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Visibility(
            visible: isWrite,
            child: IconButton(
              onPressed: () {
                setState(() {
                  oldconfig = false;
                  makeDataSend();
                });
              },
              icon: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
      body: readBoolean && !isWrite
          ? ListView(
              children: [
                dataValueWidget(context, "Viloyat nomi:",
                    dataConfig.isNotEmpty ? getRegion() : "", 5, 5),
                dataValueWidget(context, "Tashkilot  nomi:",
                    dataConfig.isNotEmpty ? getDistrict() : "", 5, 5),
                dataValueWidget(context, "Kanalning nomi:",
                    dataConfig.isNotEmpty ? getName() : "", 5, 5),
                dataValueWidget(context, "Telfon raqam:",
                    dataConfig.isNotEmpty ? getPhone() : "", 5, 5),
                dataValueWidget(context, "Papravka:",
                    dataConfig.isNotEmpty ? getPapravaka() : "", 5, 5),
                dataValueWidget(context, "Sensor turi:",
                    dataConfig.isNotEmpty ? getSesnorType() : "", 5, 5),
                dataValueWidget(context, "Ma'lumot jo'natish vaqti(min):",
                    dataConfig.isNotEmpty ? getMeasurePeroid() : "", 7, 5),
                dataValueWidget(context, "Fayl jo'natish vaqti (min):",
                    dataConfig.isNotEmpty ? getSendPeroid() : "", 7, 5),
              ],
            )
          : !readBoolean && isWrite
              ? ListView(
                  children: [
                    RegionValueWidget(
                      title: "Viloyat nomi:",
                      list: regions,
                      onChanged: (Region? region) {
                        setState(() {
                          seletionRegions = region;
                          typeCheked();
                          print(seletionRegions);

                          getDistricts();
                        });
                      },
                      value: seletionRegions,
                    ),
                    DistrictValueWidget(
                      title: "Tashkilot nomi:",
                      list: districts2,
                      onChanged: (Organization? region) {
                        setState(() {
                          selectionDistricts = region;
                          typeCheked();
                        });
                      },
                      value: selectionDistricts,
                      isExpanded: true,
                    ),
                    settingValueWidget(
                      context,
                      "Kanal nomi:",
                      "Kanal nomi kiriting...",
                      _nameladerController,
                      TextInputType.name,
                      (value) {
                        typeCheked();
                      },
                    ),
                    settingValueWidget(
                      context,
                      "Telfon raqam:",
                      "Qurilma telfon raqamni kiriting...",
                      _phoneController,
                      TextInputType.phone,
                      (value) {
                        typeCheked();
                      },
                    ),
                    DropDwanValueWidget(
                      title: "Papravka:",
                      list: corretionList(),
                      onChanged: (int? region) {
                        setState(() {
                          selectionConrrection = region!;
                        });
                      },
                      value: selectionConrrection,
                      hint: "Papravka ni kirting...",
                    ),
                    SensorTypeValueWidget(
                      title: "Sensor tipi:",
                      list: sensorType,
                      onChanged: (SensorType? region) {
                        setState(() {
                          selectionSensorType = region;
                          typeCheked();
                        });
                      },
                      value: selectionSensorType,
                    ),
                    DropDwanValueWidget(
                      title: "Ma'lumot jo'natish vaqti (mint):",
                      list: sendMinPerodList,
                      onChanged: (int? region) {
                        setState(() {
                          selectionMenusePeriod = region!;
                        });
                      },
                      value: selectionMenusePeriod,
                      hint: "Papravka ni kirting...",
                    ),
                    DropDwanValueWidget(
                      title: "Fayl jo'natish vaqti (mint):",
                      list: sendFTPInterval,
                      onChanged: (int? region) {
                        setState(() {
                          selectionSendPeriod = region!;
                        });
                      },
                      value: selectionSendPeriod,
                      hint: "Papravka ni kirting...",
                    ),
                    Visibility(
                      visible: oldconfig,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Config fayl eski ekan ma'lumotlarni yangilang...",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.8, 80)),
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

  getMeasurePeroid() {
    try {
      String fsdsd = "";
      dataConfig.forEach((element) {
        if (element.contains('DAQ')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        String sensorType1 = fsdsd.split(",")[3];
        if (sendMinPerodList.contains(int.parse(sensorType1))) {
          selectionMenusePeriod = int.parse(sensorType1);
        } else {
          selectionMenusePeriod = sendMinPerodList.first;
          oldconfig = true;
        }

        return sensorType1;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSendPeroid() {
    try {
      String fsdsd = "";
      dataConfig.forEach((element) {
        if (element.contains('FTP')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        String sensorType1 = fsdsd.split(",")[4];
        if (sendFTPInterval.contains(int.parse(sensorType1))) {
          selectionSendPeriod = int.parse(sensorType1);
        } else {
          selectionSendPeriod = sendFTPInterval[0];
          oldconfig = true;
        }

        return sensorType1;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSesnorType() {
    try {
      String fsdsd = "";
      dataConfig.forEach((element) {
        if (element.contains('SENSOR')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        String sensorType1 = fsdsd.split(",")[0];
        selectionSensorType =
            sensorType.firstWhere((element) => element!.name == sensorType1);
        return sensorType1;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getPapravaka() {
    try {
      String corretion = "";
      dataConfig.forEach((element) {
        if (element.contains('SENSOR')) {
          corretion =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (corretion != "") {
        String corretion2 = corretion.split(",")[2];
        if (corretionList().contains(int.parse(corretion2))) {
          selectionConrrection = int.parse(corretion2);
        } else {
          selectionConrrection = corretionList()[0];
          oldconfig = true;
        }

        return corretion2;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getPhone() {
    try {
      String phone = "";
      dataConfig.forEach((element) {
        if (element.contains('UPNUM')) {
          phone =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (phone != "") {
        _phoneController.text = phone;
        return phone;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getRegion() {
    try {
      String region = "";
      dataConfig.forEach((element) {
        if (element.contains('NAME1')) {
          region =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (region != "") {
        seletionRegions = regions.firstWhere(
            (element) => element!.id == int.parse(region),
            orElse: () => null);

        districts2 = districts
            .where((element) => element!.regionId == seletionRegions!.id)
            .toList();
        return seletionRegions!.name;
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

  getDistrict() {
    try {
      String district1 = "";
      dataConfig.forEach((element) {
        if (element.contains('NAME2')) {
          district1 =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (district1 != "") {
        selectionDistricts = districts
            .firstWhere((element) => element!.id == int.parse(district1));

        return selectionDistricts!.name;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getName() {
    try {
      String name = "";
      dataConfig.forEach((element) {
        if (element.contains('NAME3')) {
          name =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (name != "") {
        _nameladerController.text = name;
        return name;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  void _sendOnMessageToBluetooth() async {
    Future.delayed(Duration.zero, () => onLoading(context, "Reading data...."));
    readConunt = 0;
    List<int> list = 'SETTING#'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection!.output.add(bytes);
    await widget.connection!.output.allSent;
    print('TABLE#');
  }

  show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
