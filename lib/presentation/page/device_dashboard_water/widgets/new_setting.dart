import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_water/data/model/sensor_type.dart';
import '../../../../core/other/constants.dart';
import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import 'district_value_widget.dart';
import 'drop_dwan_value_widget.dart';
import 'region_value_widget.dart';
import 'sensor_type_value_widget.dart';
import 'setting_valeu_widget.dart';

class NewSettingsFile extends StatefulWidget {
  NewSettingsFile({Key? key}) : super(key: key);

  @override
  State<NewSettingsFile> createState() => _NewSettingsFileState();
}

class _NewSettingsFileState extends State<NewSettingsFile> {
  List<Region?> regions = [];
  List<Organization> districts = [];
  List<Organization> districts2 = [];
  List<SensorType?> sensorType = [];
  bool sending = false;

  Region? seletionRegions;
  Organization? selectionDistricts;
  SensorType? selectionSensorType;
  int? selectionConrrection = 0;
  int? selectionMenusePeriod = 60;
  int? selectionSendPeriod = 1440;

  List<int> corretions = [];
  List<int> menusePeriods = [];
  List<int> sendPeriods = [];

  int regionId = 0;
  bool readDistrict = false;

  final TextEditingController _nameladerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRgions();
    geSensorType();
    corretions = corretionList();
    menusePeriods = sendMinPerodList;
    sendPeriods = sendFTPInterval;
  }

  typeCheked() {
    if (_nameladerController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
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

  geSensorType() async {
    final database = await $FloorSmartWaterDatabase
        .databaseBuilder('app_database.db')
        .build();

    final dao = database.sensorTypeDao;
    final result = await dao.getAll();
    //print("sdasd");
    // print(result);
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
    //print("sdasd");
    // print(result);
    setState(() {
      regions = result;
    });
  }

  int coutSletion = 0;
  getDistrict() async {
    if (coutSletion == 0) {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/json/balans_tashkilotlar.json");

      final jsonResult = json.decode(data);
      List<Organization> lastHoursDataModels = List<Organization>.from(
          jsonResult.map((element) => Organization.fromJson(element)));
      districts = lastHoursDataModels;
      coutSletion = 1;
    }
    // print(seletionRegions);

    setState(() {
      districts2 = districts
          .where((element) => element.regionId == seletionRegions!.id)
          .toList();
      // print(districts2);
      selectionDistricts = districts2[0];
      readDistrict = true;
    });
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
          "Yangi sozlamalar",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        actions: [
          Visibility(
            visible: sending,
            child: IconButton(
              onPressed: () {
                makeDataSend();
              },
              icon: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          RegionValueWidget(
            title: "Viloyat nomi:",
            list: regions,
            onChanged: (Region? region) {
              setState(() {
                seletionRegions = region;
                typeCheked();
                print(seletionRegions);
                readDistrict = false;
                getDistrict();
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
            isExpanded: readDistrict,
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
            list: corretions,
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
            list: menusePeriods,
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
            list: sendPeriods,
            onChanged: (int? region) {
              setState(() {
                selectionSendPeriod = region!;
              });
            },
            value: selectionSendPeriod,
            hint: "Papravka ni kirting...",
          ),
        ],
      ),
    );
  }
}
