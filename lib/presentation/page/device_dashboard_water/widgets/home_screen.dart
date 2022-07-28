import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/data/model/organization.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/district.dart';
import '../../../../data/model/region.dart';
import 'card_second_widget.dart';
import 'card_wigdet.dart';
import 'data_value_widget.dart';
import 'on_loading.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;
  HomeScreen({
    Key? key,
    required this.title,
    this.connection,
    this.subscription,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _deviceState;
  bool isDisconnecting = false;
  bool get isConnected =>
      widget.connection != null && widget.connection!.isConnected;
  bool _connected = false;
  List<String> _messages = [];
  List<String> _dataMessage = [];
  List<Region?> regions = [];
  List<Organization?> districts = [];
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

  getAllDistase() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/balans_tashkilotlar.json");

    final jsonResult = json.decode(data);
    List<Organization> lastHoursDataModels = List<Organization>.from(
        jsonResult.map((element) => Organization.fromJson(element)));
    setState(() {
      districts = lastHoursDataModels;
    });
  }

  @override
  void initState() {
    startBluetooth();
    super.initState();
    getAllDistase();
    getRgions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
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
          Row(
            children: [
              Icon(
                Icons.bluetooth_audio_rounded,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                _dataMessage.isNotEmpty ? " " + getSiganlBlutooth() : "",
                style: GoogleFonts.roboto(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                if (_connected) {
                  onLoading(context, "Reading data....");
                  _sendOnMessageToBluetooth();
                }
              },
              icon: const Icon(Icons.update),
              color: Theme.of(context).primaryColor,
              iconSize: 25),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        _dataMessage.isNotEmpty ? getBatter() + "%" : "",
                        _dataMessage.isNotEmpty
                            ? batIcons(getBatter())
                            : Typicons.bat4),
                  ),
                  //Typicons.bat4
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        _dataMessage.isNotEmpty ? "${getSignal()}%" : "",
                        _dataMessage.isNotEmpty
                            ? sigalIcon(getSignal())
                            : Icons.signal_cellular_alt_sharp),
                  ),
                  //Icons.signal_cellular_alt_sharp,
                  Expanded(
                    flex: 1,
                    child: cardWidget(
                        context,
                        _dataMessage.isNotEmpty ? getTemp() + "°C" : "",
                        Typicons.temperatire),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, right: 2),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  cardSecondWidget(
                      context,
                      "Suv Sathi (sm):",
                      _dataMessage.isNotEmpty ? getSath() : "",
                      'assets/images/water_level.png'),
                  cardSecondWidget(
                      context,
                      "Suv Sarfi (m3/s):",
                      _dataMessage.isNotEmpty ? getSarif() : "",
                      'assets/images/speed_water.png'),
                  //Typicons.water
                ],
              ),
            ),
            dataValueWidget(context, "Viloyat nomi:",
                _dataMessage.isNotEmpty ? getRegion() : "", 5, 5),
            dataValueWidget(context, "Tashkilot nomi:",
                _dataMessage.isNotEmpty ? getDistrict() : "", 5, 5),
            dataValueWidget(context, "Kanalning nomi:",
                _dataMessage.isNotEmpty ? getName() : "", 5, 5),
            dataValueWidget(context, "Simkarta ID:",
                _dataMessage.isNotEmpty ? getSimkarta() : "", 5, 5,
                color: getSimkarta() == "" ? Colors.red : Colors.white),
            dataValueWidget(context, "Qurilmaning ID si:",
                _dataMessage.isNotEmpty ? getID() : "", 5, 5),
            dataValueWidget(context, "Koordinata tuzatishi:",
                _dataMessage.isNotEmpty ? getPapravaka() : "", 5, 5),
            dataValueWidget(context, "Location:",
                _dataMessage.isNotEmpty ? getLocation() : "", 5, 7),
            dataValueWidget(context, "Proshivka versiyasi:",
                _dataMessage.isNotEmpty ? getProshibka() : "", 5, 5),
            dataValueWidget(context, "Qurilmaning vaqti:",
                _dataMessage.isNotEmpty ? getTime() : "", 5, 5),
            dataValueWidget(context, "Sensor turi:",
                _dataMessage.isNotEmpty ? getSesnorType() : "", 5, 5),
          ],
        ),
      ),
    );
  }

  getSimkarta() {
    try {
      String fsdsd = "";
      _dataMessage.forEach((element) {
        if (element.contains('APNUM')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        return fsdsd;
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
      _dataMessage.forEach((element) {
        if (element.contains('ASESNORTYPE')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSiganlBlutooth() {
    try {
      String fsdsd = "";
      _dataMessage.forEach((element) {
        if (element.contains('ABTRSSI')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
          fsdsd = (100 + int.parse(fsdsd)).toString();
        }
      });
      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getTime() {
    try {
      String fsdsd = "";
      _dataMessage.forEach((element) {
        if (element.contains('ATIME')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getLevel() {
    try {
      String fsdsd = "";
      _dataMessage.forEach((element) {
        if (element.contains('ADIST')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getProshibka() {
    try {
      String fsdsd = "";
      _dataMessage.forEach((element) {
        if (element.contains('AFV')) {
          fsdsd =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getLocation() {
    try {
      String loction = "";
      _dataMessage.forEach((element) {
        if (element.contains('ALOCK')) {
          loction =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (loction != "") {
        return loction;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  sigalIcon(String signal) {
    try {
      int batteryInt = int.parse(signal);
      print(batteryInt);
      if (batteryInt >= 0 && batteryInt <= 10) {
        return Icons.signal_cellular_alt_1_bar;
      } else if (batteryInt > 10 && batteryInt <= 18) {
        return Icons.signal_cellular_alt_2_bar;
      } else if (batteryInt > 18 && batteryInt <= 32) {
        return Icons.signal_cellular_alt;
      }
    } catch (e) {
      print(e.toString());
      return Icons.signal_cellular_alt_sharp;
    }
  }

  getID() {
    try {
      String id = "";
      _dataMessage.forEach((element) {
        if (element.contains('AID')) {
          id =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (id != "") {
        return id;
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
      _dataMessage.forEach((element) {
        if (element.contains('ACORRECTION')) {
          corretion =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (corretion != "") {
        return corretion;
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
      _dataMessage.forEach((element) {
        if (element.contains('ANAME1')) {
          region =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (region != "") {
        Region? region1 =
            regions.firstWhere((element) => element!.id == int.parse(region));
        return region1!.name;
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
      _dataMessage.forEach((element) {
        if (element.contains('APNUM')) {
          phone =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (phone != "") {
        return phone;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getDistrict() {
    try {
      String district = "";
      _dataMessage.forEach((element) {
        if (element.contains('ANAME2')) {
          district =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (district != "") {
        Organization? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.name;
      } else {
        return "";
      }
    } catch (e) {
      return "" + e.toString();
    }
  }

  getName() {
    try {
      String name = "";
      _dataMessage.forEach((element) {
        if (element.contains('ANAME3')) {
          name =
              element.substring(element.indexOf('=') + 1, element.indexOf('#'));
        }
      });
      if (name != "") {
        return name;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSignal() {
    String signal = "";
    _dataMessage.forEach((element) {
      if (element.contains('ASIG')) {
        signal =
            element.substring(element.indexOf('=') + 1, element.indexOf(','));
      }
    });
    if (signal != "") {
      return signal;
    } else {
      return "";
    }
  }

  batIcons(String battery) {
    try {
      int batteryInt = int.parse(battery);
      if (batteryInt >= 0 && batteryInt <= 25) {
        return Typicons.bat1;
      } else if (batteryInt > 25 && batteryInt <= 50) {
        return Typicons.bat2;
      } else if (batteryInt > 50 && batteryInt <= 75) {
        return Typicons.bat3;
      } else if (batteryInt > 75 && batteryInt <= 99) {
        return Typicons.bat4;
      }
    } catch (e) {
      return Typicons.bat4;
    }
  }

  getSath() {
    String sath = "";

    _dataMessage.forEach((element) {
      if (element.contains('ASATH')) {
        sath =
            element.substring(element.indexOf('=') + 1, element.indexOf('#'));
      }
    });
    if (sath != "") {
      return (int.parse(sath) / 10).toStringAsFixed(1);
    } else {
      return "";
    }
  }

  getBatter() {
    String battery = "";

    _dataMessage.forEach((element) {
      if (element.contains('ABAT')) {
        battery =
            element.substring(element.indexOf('=') + 1, element.indexOf('#'));
      }
    });
    if (battery != "") {
      return battery;
    } else {
      return "";
    }
  }

  getSarif() {
    String sarif = "";
    _dataMessage.forEach((element) {
      if (element.contains('ASARF')) {
        sarif =
            element.substring(element.indexOf('=') + 1, element.indexOf('#'));
      }
    });

    if (sarif != "") {
      return (int.parse(sarif) / 1000.0).toStringAsFixed(3);
    } else {
      return "";
    }
  }

  getTemp() {
    String temp = "";
    _dataMessage.forEach((element) {
      if (element.contains('ATEMP')) {
        temp =
            element.substring(element.indexOf('=') + 1, element.indexOf('#'));
      }
    });

    if (temp != "") {
      return temp;
    } else {
      return "";
    }
  }

  void _connect() async {
    Future.delayed(Duration.zero, () => onLoading(context, "Reading data...."));
    if (_connected) {
      try {
        widget.subscription!.onData((data) {
          setState(() {
            if (utf8.decode(data) != "") {
              var messageList = utf8.decode(data).split("\r\n");
              for (var message in messageList) {
                if (message != "") {
                  if (message.contains("END#")) {
                    Navigator.of(context).pop();
                  }
                  _dataMessage.add(message);
                }
              }
              print(_dataMessage);
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
    _dataMessage.clear();
    List<int> list = 'HOME#'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection!.output.add(bytes);
    await widget.connection!.output.allSent;
    print('HOME#');

    setState(() {
      _deviceState = 1; // device on
    });
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
