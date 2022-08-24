import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_water/data/model/water_info.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../core/units/mp_units.dart';
import '../../../../data/db/database/smart_water_database.dart';
import '../../../../data/model/mqtt_waring_data.dart';
import '../../../../data/model/organization.dart';
import '../../../../data/model/region.dart';
import 'no_data_error.dart';

class MessageMqttData extends StatefulWidget {
  final WaterInfo info;
  MessageMqttData({Key? key, required this.info}) : super(key: key);

  @override
  State<MessageMqttData> createState() => _MessageMqttDataState();
}

class _MessageMqttDataState extends State<MessageMqttData> {
  final client = MqttServerClient('185.196.214.190', 'flutter_mqtt');
  var pongCount = 0;
  List<String> dataList = [];
  List<MqttWaringData> mqttWaringData = [];
  List<Region?> regions = [];
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

  @override
  void initState() {
    super.initState();
    connect();
    getAllDistase();
    getRgions();
  }

  @override
  void dispose() {
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
        elevation: 2,
        title: Text(
          "${widget.info.name}",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: !loading
          ? noDataErrorWidget(LocaleKeys.no_data_text.tr())
          : ListView.builder(
              itemCount: mqttWaringData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Card(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: mqttNamedat(
                                    mqttWaringData[index].p8 == null &&
                                            mqttWaringData[index].p8 == ""
                                        ? mqttWaringData[index].p7
                                        : mqttWaringData[index].p8),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  mqttWaringData[index].p8 == null &&
                                          mqttWaringData[index].p8 == ""
                                      ? mqttIcon(mqttWaringData[index].p7)
                                      : mqttIcon(mqttWaringData[index].p8),
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              openMap(
                                getLcoation(mqttWaringData[index].p6),
                              );
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    getLcoation(mqttWaringData[index].p6),
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrlString(
                                  "tel:${mqttWaringData[index].p5}");
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    mqttWaringData[index].p5,
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.timer_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  mqttWaringData[index].t,
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  getLcoation(String location) {
    try {
      var locationList = location.split(",");
      return "${locationList[3]},${locationList[4]}";
    } catch (e) {
      return "";
    }
  }

  openMap(String assd) {
    try {
      if (assd != "") {
        var locationList = assd.split(",");
        MapUtils.openMap(
            double.parse(locationList[0]), double.parse(locationList[1]));
      }
    } catch (e) {
      print(e);
    }
  }

  mqttIcon(String assd) {
    try {
      if (assd.contains("MoveSecond")) {
        return LocaleKeys.message_mqtt_text_1.tr();
      } else if (assd.contains("MoveFirst")) {
        return LocaleKeys.message_mqtt_text_2.tr();
      } else if (assd.contains("BluetoothOn")) {
        return LocaleKeys.message_mqtt_text_3.tr();
      } else if (assd.contains("DeviceReset")) {
        return LocaleKeys.message_mqtt_text_4.tr();
      } else if (assd.contains("CorrectionChange")) {
        return LocaleKeys.message_mqtt_text_5.tr();
      }
    } catch (e) {
      return "";
    }
  }

  mqttNamedat(String assd) {
    try {
      if (assd.contains("MoveSecond")) {
        return const Icon(
          Icons.warning,
          color: Colors.red,
          size: 30,
        );
      } else if (assd.contains("MoveFirst")) {
        return const Icon(
          Icons.warning,
          color: Colors.red,
          size: 30,
        );
      } else if (assd.contains("BluetoothOn")) {
        return const Icon(
          Icons.bluetooth_connected,
          color: Colors.blue,
          size: 30,
        );
      } else if (assd.contains("DeviceReset")) {
        return const Icon(
          Icons.restart_alt,
          color: Colors.blue,
          size: 30,
        );
      } else if (assd.contains("CorrectionChange")) {
        return const Icon(
          Icons.change_circle,
          color: Colors.blue,
          size: 30,
        );
      }
    } catch (e) {
      return const Icon(
        Icons.message,
        color: Colors.blue,
        size: 30,
      );
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
        if (topics[4] != "info" && topics[4] != "data") {
          setState(() {
            loading = true;
            mqttWaringData.add(MqttWaringData.fromJson(json.decode(pt)));
            dataList.add(pt);
            //  mqttInfo = WaterMqttInfo.fromJson(json.decode(pt));
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
