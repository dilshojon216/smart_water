import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/pump_stations.dart';
import '../../water_data/widgets/no_internet_widget.dart';
import '../pump_viewmodel.dart';
import 'all_info_mqtt.dart';

class LastDataPump extends StatefulWidget {
  LastDataPump({Key? key}) : super(key: key);

  @override
  State<LastDataPump> createState() => _LastDataPumpState();
}

class _LastDataPumpState extends State<LastDataPump> {
  List<PumpMqttData> pumpMqttData = [];
  List<PumpStations> pumpStations = [];
  var pongCount = 0;
  int countSubscribed = 0;

  bool isLoading = true;
  bool nodata = false;

  bool internetConnection = true;
  late StreamSubscription? subscription;
  final client = MqttServerClient(
      '185.196.214.190', 'flutter_mqtt${DateTime.now().microsecondsSinceEpoch}',
      maxConnectionAttempts: 10000);
  @override
  void initState() {
    super.initState();
    init();
  }

  Timer? countdownTimer;

  startTime() async {
    countdownTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        isLoading = false;
        _.cancel();
      });
    });
  }

  void initValue() async {
    try {
      bool internetConnection1 =
          await InternetConnectionChecker().hasConnection;

      setState(() {
        internetConnection = internetConnection1;
      });

      if (internetConnection) {
        connect();
        startTime();
      }
    } catch (e) {
      print(e);
    }

    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hashInternet = status == InternetConnectionStatus.connected;
      setState(() {
        internetConnection = hashInternet;
      });
    });
  }

  init() {
    pumpStations = context.read<PumpViewModel>().pumpStations;
    print("salom" + pumpStations.length.toString());
    if (pumpStations.length > 1) {
      pumpStations.forEach((element) {
        print(element);
        pumpMqttData.add(PumpMqttData(stations: element));
      });

      initValue();
    } else {
      setState(() {
        nodata = true;
        isLoading = false;
      });
    }
  }

  stetData() {
    client.subscribe(
        "${pumpMqttData[countSubscribed].stations.topic}:CWTIO-RTU",
        MqttQos.exactlyOnce);
    print("${pumpMqttData[countSubscribed].stations.topic}:CWTIO-RTU");
  }

  @override
  void dispose() {
    try {
      client.disconnect();

      if (countdownTimer != null) {
        countdownTimer!.cancel();
      }
      if (subscription != null) {
        subscription!.cancel();
      }
    } catch (e) {
      print(e.toString());
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return internetConnection
        ? isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : nodata
                ? Center(
                    child: Text(
                      "No data",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: pumpMqttData.length,
                    itemBuilder: (context, index) {
                      return _post(pumpMqttData[index], context);
                    },
                  )
        : noInternetWidget();
  }

  Widget _post(PumpMqttData post, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (post.positiveFlow != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllInfoMqttPump(
                post: post,
              ),
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(5.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: post.time != null
                        ? colorLine(timeConvertMqtt(post.time!))
                        : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            if (post.stations.latitude != "" &&
                                post.stations.longitude != "") {
                              goMaps(post);
                            }
                          },
                          icon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Expanded(
                      flex: 7,
                      child: AutoSizeText(
                        post.stations.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        LocaleKeys.pump_text_2.tr(),
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        post.positiveFlow != null
                            ? "${post.positiveFlow!.toStringAsFixed(2)} m3"
                            : "",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        LocaleKeys.pump_text_3.tr(),
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        post.tutoleFlow != null
                            ? "${post.tutoleFlow!.toStringAsFixed(2)} m3"
                            : "",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        LocaleKeys.vaqt_data_text_1.tr(),
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: AutoSizeText(
                        post.time != null ? timeConvertMqtt(post.time!) : "",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  goMaps(PumpMqttData post) {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${post.stations.latitude},${post.stations.latitude}';
    launchUrl(Uri.parse(googleUrl));
  }

  timeConvertMqtt(String time) {
    //22/07/18,00:12:14+00
    try {
      String dateTime = "20${time}".replaceAll("/", "-").replaceAll(",", " ");
      DateTime date = DateTime.parse(dateTime);
      var jiffy1 = Jiffy(date, "YYYY-MM-dd HH:mm");

      return jiffy1.format("yyyy-MM-dd HH:mm");
    } catch (e) {
      print(e.toString());
      return "2020-01-01 00:00";
    }
  }

  Color colorLine(String from) {
    try {
      int diffetnt = daysBetween(DateTime.parse(from), DateTime.now());
      if (diffetnt <= 1) {
        return Colors.blue;
      } else if (diffetnt > 1 && diffetnt <= 7) {
        return Colors.yellow;
      } else if (diffetnt > 7 && diffetnt <= 30) {
        return Colors.red;
      } else {
        return Colors.red;
      }
    } catch (e) {
      return Colors.red;
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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

        String data = pt.substring(0, pt.length - 1);
        setState(() {
          var dataList = data.split("R");
          print(dataList.length);
          if (dataList.length == 10) {
            pumpMqttData.forEach((element) {
              if (c[0].topic.contains("${element.stations.topic}:CWTIO-RTU")) {
                element.positiveFlow = double.parse(
                    dataList[6].substring(1, dataList[6].indexOf(",")));
                element.tutoleFlow = double.parse(
                    dataList[8].substring(1, dataList[8].indexOf(",")));
                element.time = dataList[1].substring(3, 17);
              }
            });
          }

          if (countdownTimer != null) {
            isLoading = false;
            countdownTimer!.cancel();
          }
        });
        context
            .read<PumpViewModel>()
            .changePumpMqttData(pumpMqttData, countSubscribed);
      });
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void onSubscribed(String topic) {
    if (countSubscribed < pumpMqttData.length) {
      print(countSubscribed.toString() + pumpMqttData.length.toString());
      countSubscribed++;
      if (pumpMqttData.length != countSubscribed) {
        client.subscribe(
            "${pumpMqttData[countSubscribed].stations.topic}:CWTIO-RTU",
            MqttQos.exactlyOnce);
      }
    } else {
      countSubscribed = 0;
    }
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

class PumpMqttData {
  PumpStations stations;
  double? positiveFlow;
  double? tutoleFlow;
  String? time;
  PumpMqttData({
    required this.stations,
    this.positiveFlow,
    this.tutoleFlow,
    this.time,
  });
}
