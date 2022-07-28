import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/page/pump_data/widgets/pump_model_mqtt_data.dart';
import 'package:smart_water/presentation/page/pump_data/widgets/stations_mqtt_well_data.dart';
import 'package:smart_water/presentation/page/water_data/widgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/water_mqtt_info.dart';
import '../../../../data/model/well_mqtt_data.dart';

class LastMqttDataWell extends StatefulWidget {
  LastMqttDataWell({Key? key}) : super(key: key);

  @override
  State<LastMqttDataWell> createState() => _LastMqttDataWellState();
}

class _LastMqttDataWellState extends State<LastMqttDataWell> {
  List<WellMqttModel> waterMqttModels = [];
  List<String> waterMqttModelsStr = [];
  int countSubscribed = 0;
  bool internetConnection = false;
  late StreamSubscription? subscription;
  var pongCount = 0;
  final client =
      MqttServerClient('185.196.214.190', 'flutter_mqtt${DateTime.now()}');
  bool isLoading = true;
  Timer? countdownTimer;

  startTime() async {
    countdownTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        isLoading = false;
        _.cancel();
      });
    });
  }

  @override
  void initState() {
    getData();
    initValue();

    super.initState();
  }

  getData() async {
    waterMqttModels = [];

    var _prefs = await SharedPreferences.getInstance();
    List<String>? wellIMEiList = _prefs.getStringList("wellIMEiList") ?? [];

    wellIMEiList.forEach((element) {
      waterMqttModels.add(WellMqttModel(code: element));
    });
    print(waterMqttModels.length);
    setState(() {
      waterMqttModelsStr = wellIMEiList;
    });
  }

  void stetData() {
    client.subscribe(
        "M/+/+/${waterMqttModelsStr[countSubscribed]}/#", MqttQos.exactlyOnce);
  }

  void initValue() async {
    bool internetConnection1 = await InternetConnectionChecker().hasConnection;

    setState(() {
      internetConnection = internetConnection1;
    });

    if (internetConnection) {
      connect();
      startTime();
    }

    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hashInternet = status == InternetConnectionStatus.connected;
      setState(() {
        internetConnection = hashInternet;
      });
    });
  }

  @override
  void dispose() {
    client.disconnect();
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
    if (subscription != null) {
      subscription!.cancel();
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
            : ListView.builder(
                itemCount: waterMqttModels.length,
                itemBuilder: (context, index) {
                  return _post(waterMqttModels[index], context);
                },
              )
        : noInternetWidget();
  }

  Widget _post(WellMqttModel post, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (post.info != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StationsMqttWellData(
                        mqttModel: post,
                      )));
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
                    color: post.data != null
                        ? colorLine(timeConvertMqtt(post.data!.t))
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
                            if (post.info != null) {
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
                        post.info == null ? post.code : post.info!.p3,
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
                        "Suv sathi:",
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
                        post.data != null ? getSath(post.data!.d) : "",
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
                        "Sho'rlanish:",
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
                        post.data != null ? getShorlanish(post.data!) : "",
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
                        "Temperatura:",
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
                        post.data != null ? getTemp(post.data!.q) : "",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.deepOrange,
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
                        "Vaqti:",
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
                        post.data != null ? timeConvertMqtt(post.data!.t) : "",
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

  getShorlanish(WellMqttData data) {
    try {
      double tempInt = int.parse(data.q) / 10.0;
      double dataSh = double.parse(data.r);

      double kFF = 1.0 + 0.02 * (tempInt - 25);
      double kF = dataSh / kFF;

      if (kF < 700) {
        if (kF == 0) {
          return "0 g/L";
        } else {
          return "${((kF - 27) / 350.0).toStringAsFixed(3)} g/L";
        }
      } else {
        return "${((kF - 40) / 380.0).toStringAsFixed(3)} g/L";
      }
    } catch (e) {
      print(e);
      return data.r;
    }
  }

  getTemp(String data) {
    try {
      int sath = int.parse(data);
      return "${(sath / 10.0).toStringAsFixed(2)} °C";
    } catch (e) {
      print(e);
      return data;
    }
  }

  getSath(String data) {
    try {
      int sath = int.parse(data);
      return "${(sath / 10.0).toStringAsFixed(2)} sm";
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  goMaps(WellMqttModel post) {
    getLogiton(post);
    if (lang != "" && lat != "") {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lang,$lat';
      launchUrl(Uri.parse(googleUrl));
    }
  }

  getLocation(WellMqttModel post) {
    try {
      String loction = "";
      if (post.info != null) {
        loction = post.info!.p6;
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
  getLogiton(WellMqttModel post) {
    String sdsdwsd = getLocation(post);
    if (sdsdwsd != "") {
      var sdsd = sdsdwsd.split(",");
      lang = sdsd[3];
      lat = sdsd[4];
    } else {
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
        var topics = c[0].topic.split("/");

        if (topics[4] == "info") {
          setState(() {
            isLoading = false;
            if (countdownTimer != null) {
              countdownTimer!.cancel();
            }

            waterMqttModels.forEach((element) {
              if (element.code == topics[3]) {
                element.info = WaterMqttInfo.fromJson(jsonDecode(pt));
              }
            });
          });
          context
              .read<PumpModelMqttData>()
              .changeData(waterMqttModels, countSubscribed);
        } else if (topics[4] == "data") {
          setState(() {
            isLoading = false;
            if (countdownTimer != null) {
              countdownTimer!.cancel();
            }
            waterMqttModels.forEach((element) {
              if (element.code == topics[3]) {
                element.data = WellMqttData.fromJson(jsonDecode(pt));
              }
            });
          });
          context
              .read<PumpModelMqttData>()
              .changeData(waterMqttModels, countSubscribed);
        }
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
    if (countSubscribed < waterMqttModelsStr.length) {
      print(countSubscribed.toString() + waterMqttModels.length.toString());
      countSubscribed++;
      client.subscribe("M/+/+/${waterMqttModelsStr[countSubscribed]}/#",
          MqttQos.exactlyOnce);
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

class WellMqttModel {
  String code;

  WaterMqttInfo? info;
  WellMqttData? data;

  WellMqttModel({
    required this.code,
    this.info,
    this.data,
  });
}
