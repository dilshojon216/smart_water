import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../data/model/water_mqtt_data.dart';
import '../../../../data/model/water_mqtt_info.dart';

class MessageSendDevice extends StatefulWidget {
  WaterMqttInfo info;
  WaterMqttData? mqttData;
  MqttServerClient? client;
  MessageSendDevice({
    Key? key,
    required this.mqttData,
    required this.info,
    this.client,
  }) : super(key: key);

  @override
  State<MessageSendDevice> createState() => _MessageSendDeviceState();
}

class _MessageSendDeviceState extends State<MessageSendDevice> {
  final client = MqttServerClient(
    '185.196.214.190',
    'flutter_mqtt${DateTime.now().microsecondsSinceEpoch}',
  );
  int corec = 0;
  String topic = "";
  String error = "";
  @override
  void initState() {
    super.initState();

    corec = int.parse(widget.mqttData!.c);
    topic = "R/${widget.info.p1}/${widget.info.p2}/${widget.info.i}/receive";
    connect();
  }

  var pongCount = 0;
  sendDataCorecMqtt() async {
    try {
      bool internetConnection = await InternetConnectionChecker().hasConnection;

      if (internetConnection) {
        MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        builder.addString('COR=$corec');
        client.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: true,
        );
        Navigator.pop(context, false);
      } else {
        setState(() {
          error = "No internet connection";
        });
      }
    } catch (e) {
      print(e.toString());
      Navigator.pop(context, false);
    }
  }

  sendDataBTMqtt() async {
    try {
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        builder.addString('BT=1');
        client.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: true,
        );
        Navigator.pop(context, false);
      } else {
        setState(() {
          error = "No internet connection";
        });
      }
    } catch (e) {
      print(e.toString());
      Navigator.pop(context, false);
    }
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              LocaleKeys.message_send_text_1.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "+",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        corec++;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    corec.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "-",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        corec--;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                sendDataCorecMqtt();
              },
              child: Text(
                LocaleKeys.message_send_text_3.tr(),
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.message_send_text_2.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                sendDataBTMqtt();
              },
              child: Text(
                LocaleKeys.message_send_text_4.tr(),
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
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
    } else {
      /// Use status here rather than state if you also want the broker retursn code.
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
