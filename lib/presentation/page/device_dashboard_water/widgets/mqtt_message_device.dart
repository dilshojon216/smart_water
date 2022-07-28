import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_water/presentation/page/water_data/widgets/no_internet_widget.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../../../data/model/water_mqtt_data.dart';
import '../../../../data/model/water_mqtt_info.dart';
import '../../water_data/widgets/no_data_error.dart';
import 'card_second_widget.dart';
import 'card_wigdet.dart';
import 'data_value_widget.dart';

class MqttMessageDevice extends StatefulWidget {
  String title;
  String code;

  MqttMessageDevice({
    Key? key,
    required this.code,
    required this.title,
  }) : super(key: key);

  @override
  State<MqttMessageDevice> createState() => _MqttMessageDeviceState();
}

class _MqttMessageDeviceState extends State<MqttMessageDevice> {
  final client = MqttServerClient('185.196.214.190',
      'flutter_mqtt${DateTime.now().millisecondsSinceEpoch}');
  var pongCount = 0;
  List<String> dataList = [];
  WaterMqttData? mqttData;
  WaterMqttInfo? mqttInfo;
  List<Region?> regions = [];
  List<Organization?> districts = [];
  int? _deviceState;
  bool isDisconnecting = false;

  bool _connected = false;
  bool internetConnection = true;
  bool isLoading = true;
  Timer? countdownTimer;

  late StreamSubscription subscription;
  @override
  void initState() {
    super.initState();

    connect();
    startTime();
    getAllDistase();
    getRgions();
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

  bool loading = false;
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

  loadingData() async {
    bool internetConnection = await InternetConnectionChecker().hasConnection;
    if (internetConnection) {
      connect();
      startTime();
    } else {
      setState(() {
        internetConnection = false;
      });
    }
  }

  int readConunt = 0;

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  startTime() async {
    countdownTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        isLoading = false;
        _.cancel();
      });
    });
  }

  void stetData() {
    print("W/+/+/${widget.code}/#");
    client.subscribe("W/+/+/${widget.code}/#", MqttQos.exactlyOnce);
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
      body: internetConnection
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : mqttData != null || mqttInfo != null
                  ? SingleChildScrollView(
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
                                      mqttInfo != null ? getBatter() + "%" : "",
                                      mqttInfo != null
                                          ? batIcons(getBatter())
                                          : Typicons.bat4),
                                ),
                                //Typicons.bat4
                                Expanded(
                                  flex: 1,
                                  child: cardWidget(
                                      context,
                                      mqttInfo != null ? "${getSignal()}%" : "",
                                      mqttInfo != null
                                          ? sigalIcon(getSignal())
                                          : Icons.signal_cellular_alt_sharp),
                                ),
                                //Icons.signal_cellular_alt_sharp,
                                Expanded(
                                  flex: 1,
                                  child: cardWidget(
                                      context,
                                      mqttInfo != null ? getTemp() + "°C" : "",
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
                                    mqttData != null ? getSath() : "",
                                    'assets/images/water_level.png'),
                                cardSecondWidget(
                                    context,
                                    "Suv Sarfi (m3/s):",
                                    mqttData != null ? getSarif() : "",
                                    'assets/images/speed_water.png'),
                                //Typicons.water
                              ],
                            ),
                          ),
                          dataValueWidget(context, "Data kelgan  vaqti:",
                              mqttInfo != null ? getTimeData() : "", 5, 5),
                          dataValueWidget(context, "Viloyat nomi:",
                              mqttInfo != null ? getRegion() : "", 5, 5),
                          dataValueWidget(context, "Tashkilot nomi:",
                              mqttInfo != null ? getDistrict() : "", 5, 5),
                          dataValueWidget(context, "Kanalning nomi:",
                              mqttInfo != null ? getName() : "", 5, 5),
                          dataValueWidget(context, "Qurilmaning ID si:",
                              mqttInfo != null ? getID() : "", 5, 5),
                          dataValueWidget(context, "Koordinata tuzatishi:",
                              mqttInfo != null ? getPapravaka() : "", 5, 5),
                          dataValueWidget(context, "Location:",
                              mqttInfo != null ? getLocation() : "", 5, 7),
                          dataValueWidget(context, "Info kelgan  vaqti:",
                              mqttInfo != null ? getTimeInfo() : "", 5, 5),
                        ],
                      ),
                    )
                  : noDataErrorWidget("Ma'lumot yo'q")
          : noInternetWidget(),
    );
  }

  getSesnorType() {
    try {
      String fsdsd = "";

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

      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getTimeInfo() {
    try {
      String fsdsd = "";
      if (mqttInfo != null) {
        fsdsd = mqttInfo!.t;
      }
      if (fsdsd != "") {
        return fsdsd;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getTimeData() {
    try {
      String fsdsd = "";
      if (mqttData != null) {
        fsdsd = mqttData!.t;
      }
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
      if (mqttInfo != null) {
        loction = mqttInfo!.p6;
      }
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
      if (mqttInfo != null) {
        id = mqttInfo!.p16;
      }
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
      if (mqttData != null) {
        corretion = mqttData!.c;
      }
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
      if (mqttInfo != null) {
        region = mqttInfo!.p1;
      }

      if (region != "") {
        Region? region1 =
            regions.firstWhere((element) => element!.id == int.parse(region));
        return region1!.name;
      } else {
        return region;
      }
    } catch (e) {
      return mqttInfo!.p1;
    }
  }

  getPhone() {
    try {
      String phone = "";
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
      if (mqttInfo != null) {
        district = mqttInfo!.p2;
      }
      if (district != "") {
        Organization? district1 = districts
            .firstWhere((element) => element!.id == int.parse(district));
        return district1!.name;
      } else {
        return "";
      }
    } catch (e) {
      return mqttInfo!.p2;
    }
  }

  getName() {
    try {
      String name = "";
      if (mqttInfo != null) {
        name = mqttInfo!.p3;
      }
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
    if (mqttData != null) {
      signal = mqttInfo!.p9;
    }
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
      } else if (batteryInt > 75 && batteryInt <= 100) {
        return Typicons.bat4;
      }
    } catch (e) {
      return Typicons.bat4;
    }
  }

  getSath() {
    String sath = "";
    if (mqttData != null) {
      sath = mqttData!.d;
    }
    if (sath != "") {
      return (int.parse(sath) / 10).toStringAsFixed(1);
    } else {
      return "";
    }
  }

  getBatter() {
    String battery = "";
    if (mqttInfo != null) {
      battery = mqttInfo!.p8;
    }
    if (battery != "") {
      return battery;
    } else {
      return "";
    }
  }

  getSarif() {
    String sarif = "";
    if (mqttData != null) {
      sarif = mqttData!.v;
      print(sarif);
    }
    if (sarif != "") {
      return (int.parse(sarif) / 1000.0).toStringAsFixed(3);
    } else {
      return "";
    }
  }

  getTemp() {
    String temp = "";
    if (mqttInfo != null) {
      temp = mqttInfo!.p7;
    }
    if (temp != "") {
      return temp;
    } else {
      return "";
    }
  }

  void connect() async {
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
      stetData();

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        var topics = c[0].topic.split("/");
        if (topics[4] == "info") {
          setState(() {
            dataList.add(pt);
            mqttInfo = WaterMqttInfo.fromJson(json.decode(pt));
          });
        } else if (topics[4] == "data") {
          setState(() {
            mqttData = WaterMqttData.fromJson(json.decode(pt));
          });
        }

        setState(() {
          isLoading = false;
          //  dataList.add(pt);
          if (countdownTimer != null) {
            countdownTimer!.cancel();
          }
        });
        print('');
      });
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
    client.subscribe(topic, MqttQos.exactlyOnce);
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
    if (pongCount == 3) {
      print('EXAMPLE:: Pong count is correct');
    } else {
      print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    }
  }

  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
    pongCount++;
  }
}
