import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_water/data/model/water_info.dart';
import 'package:smart_water/data/model/water_mqtt_data.dart';
import 'package:smart_water/data/model/water_mqtt_info.dart';
import 'package:smart_water/presentation/page/water_data/widgets/no_data_error.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../device_dashboard_water/widgets/card_second_widget.dart';
import '../../device_dashboard_water/widgets/card_wigdet.dart';
import '../../device_dashboard_water/widgets/data_value_widget.dart';
import 'message_send_device.dart';

class DataMqttAll extends StatefulWidget {
  final WaterInfo info;
  DataMqttAll({Key? key, required this.info}) : super(key: key);

  @override
  State<DataMqttAll> createState() => _DataMqttAllState();
}

class _DataMqttAllState extends State<DataMqttAll> {
  final client = MqttServerClient('185.196.214.190',
      'flutter_mqtt${DateTime.now().millisecondsSinceEpoch}');
  var pongCount = 0;
  List<String> dataList = [];
  WaterMqttData? mqttData;
  WaterMqttInfo? mqttInfo;
  List<Region?> regions = [];
  bool isLoading = true;
  Timer? countdownTimer;
  String topic = "";
  bool internetConnection = false;
  late StreamSubscription subscription;
  List<Organization?> districts = [];
  void stetData() {
    client.subscribe("W/+/+/${widget.info.code}/#", MqttQos.exactlyOnce);
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

  startTime() async {
    countdownTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        isLoading = false;
        _.cancel();
      });
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
    super.initState();
    loadingData();

    getAllDistase();
    getRgions();
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

  @override
  void dispose() {
    //subscription.cancel();
    countdownTimer!.cancel();
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: statusBar(context),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Theme.of(context).primaryColor,
          iconSize: 20,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showInfo();
            },
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            iconSize: 20,
          ),
        ],
        elevation: 2,
        title: Text(
          "${widget.info.name}",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : mqttData == null && mqttInfo == null
              ? noDataErrorWidget(LocaleKeys.no_data_text.tr())
              : SingleChildScrollView(
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
                                LocaleKeys.suv_sathi_data_text_2
                                    .tr()
                                    .replaceAll("\n", ""),
                                mqttData != null ? getSath() : "",
                                'assets/images/water_level.png'),
                            cardSecondWidget(
                                context,
                                LocaleKeys.suv_sarfi_data_text
                                    .tr()
                                    .replaceAll("\n", ""),
                                mqttData != null ? getSarif() : "",
                                'assets/images/speed_water.png'),
                            //Typicons.water
                          ],
                        ),
                      ),
                      dataValueWidget(context, LocaleKeys.viloyat_titel.tr(),
                          mqttInfo != null ? getRegion() : "", 5, 5),
                      dataValueWidget(context, LocaleKeys.tuman_title.tr(),
                          mqttInfo != null ? getDistrict() : "", 5, 5),
                      dataValueWidget(context, LocaleKeys.kanal_nomi.tr(),
                          mqttInfo != null ? getName() : "", 5, 5),
                      dataValueWidget(context, LocaleKeys.id_text.tr(),
                          mqttInfo != null ? getID() : "", 5, 5),
                      dataValueWidget(context, LocaleKeys.paprvaka_title.tr(),
                          mqttInfo != null ? getPapravaka() : "", 5, 5),
                      GestureDetector(
                        onTap: () {
                          goMaps();
                        },
                        child: dataValueWidget(context, "Location:",
                            mqttInfo != null ? getLocation() : "", 5, 7),
                      ),
                      dataValueWidget(context, LocaleKeys.last_data_text.tr(),
                          mqttInfo != null ? getTime() : "", 5, 5),
                    ],
                  ),
                ),
    );
  }

  goMaps() {
    getLogiton();
    if (lang != "" && lat != "") {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lang,$lat';
      launchUrl(Uri.parse(googleUrl));
    }
  }

  getLocation() {
    try {
      String loction = "";
      if (mqttInfo == null) {
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

  String lang = "";
  String lat = "";
  getLogiton() {
    String sdsdwsd = getLocation();
    if (sdsdwsd != "") {
      var sdsd = sdsdwsd.split(",");
      lang = sdsd[3];
      lat = sdsd[4];
    } else {
      return "";
    }
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

  getTime() {
    try {
      String fsdsd = "";
      if (mqttInfo != null) {
        fsdsd = mqttInfo!.t;
      }
      if (fsdsd != "") {
        return timeConvertMqtt(fsdsd);
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  timeConvertMqtt(String time) {
    //22/07/18,00:12:14+00
    try {
      String dateTime = "20${time}".replaceAll("/", "-").replaceAll(",", " ");
      DateTime date = DateTime.parse(dateTime);
      var jiffy1 = Jiffy(date, "YYYY-MM-dd HH:mm")
          .add(duration: const Duration(hours: 5));
      return jiffy1.format("yyyy-MM-dd HH:mm");
    } catch (e) {
      print(e.toString());
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
        return int.parse(corretion).toString();
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

  void showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Xabar jo'natish",
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: MessageSendDevice(
                  info: mqttInfo!, mqttData: mqttData!, client: client),
            );
          },
        );
      },
    );
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
            isLoading = false;
            if (countdownTimer != null) {
              countdownTimer!.cancel();
            }
            mqttInfo = WaterMqttInfo.fromJson(json.decode(pt));
          });
        } else if (topics[4] == "data") {
          setState(() {
            mqttData = WaterMqttData.fromJson(json.decode(pt));
          });
        }

        print('');
      });
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
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
