import 'dart:async';
import 'dart:convert';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/other/status_bar.dart';
import '../../../../data/model/water_info.dart';
import '../../../../data/model/water_mqtt_data.dart';
import '../../../../data/model/water_mqtt_info.dart';
import 'info_water_mqtt_data.dart';
import 'water_mqtt_model.dart';

class WaterMqttAll extends StatefulWidget {
  WaterMqttAll({Key? key}) : super(key: key);

  @override
  State<WaterMqttAll> createState() => _WaterMqttAllState();
}

class _WaterMqttAllState extends State<WaterMqttAll> {
  List<String> waterMqttModelsStr = [];
  List<WaterMqttModel> waterMqttModels = [];

  int countSubscribed = 0;

  var pongCount = 0;

  final client = MqttServerClient(
      '185.196.214.190', 'flutter_mqtt${DateTime.now().microsecondsSinceEpoch}',
      maxConnectionAttempts: 10000);
  bool isLoading = true;

  bool internetConnection = true;
  late StreamSubscription? subscription;

  Timer? countdownTimer;

  @override
  void initState() {
    getData();
    //initValue();
    connect();
    startTime();
    super.initState();
  }

  getData() async {
    waterMqttModels = [];

    var _prefs = await SharedPreferences.getInstance();
    List<String> wellIMEiList = _prefs.getStringList("waterIMEIList") ?? [];

    wellIMEiList.forEach((element) {
      waterMqttModels.add(WaterMqttModel(code: element));
    });

    setState(() {
      waterMqttModelsStr = wellIMEiList;
    });
    print(waterMqttModelsStr.length);
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
    client.subscribe(
        "W/+/+/${waterMqttModelsStr[countSubscribed]}/#", MqttQos.exactlyOnce);
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
    // if (subscription != null) {
    //   subscription!.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: waterMqttModels.length,
            itemBuilder: (context, index) {
              return _post(waterMqttModels[index], context);
            },
          );
  }

  Widget _post(WaterMqttModel post, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (post.info != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InfoWaterMqttData(
                        waterMqttModel: post,
                        client: client,
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
                        LocaleKeys.mqtt_all_water_text_1.tr(),
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
                        post.data != null ? getSath("${post.data!.d}") : "",
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
                        LocaleKeys.mqtt_all_water_text_2.tr(),
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
                        post.data != null ? getSarfi("${post.data!.v}") : "",
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
                        LocaleKeys.mqtt_all_water_text_3.tr(),
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

  goMaps(WaterMqttModel post) {
    getLogiton(post);
    if (lang != "" && lat != "") {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lang,$lat';
      launchUrl(Uri.parse(googleUrl));
    }
  }

  getLocation(WaterMqttModel post) {
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
  getLogiton(WaterMqttModel post) {
    try {
      String sdsdwsd = getLocation(post);
      if (sdsdwsd != "") {
        var sdsd = sdsdwsd.split(",");
        if (sdsd.length > 5) {
          lang = sdsd[3];
          lat = sdsd[4];
        }
        print(sdsd);
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  getSarfi(String data) {
    try {
      int sath = int.parse(data);
      return "${(sath / 1000.0).toStringAsFixed(3)} m3/s";
    } catch (e) {
      print(e.toString());
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

  Color colorLine(String from) {
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
              .read<WaterMqttDataModel>()
              .changeData(waterMqttModels, countSubscribed);
        } else if (topics[4] == "data") {
          setState(() {
            isLoading = false;
            if (countdownTimer != null) {
              countdownTimer!.cancel();
            }
            waterMqttModels.forEach((element) {
              if (element.code == topics[3]) {
                element.data = WaterMqttData.fromJson(jsonDecode(pt));
              }
            });
          });
          context
              .read<WaterMqttDataModel>()
              .changeData(waterMqttModels, countSubscribed);
        }
        if (countSubscribed < waterMqttModelsStr.length) {
          countSubscribed++;
          if (waterMqttModelsStr.length != countSubscribed) {
            client.subscribe("W/+/+/${waterMqttModelsStr[countSubscribed]}/#",
                MqttQos.exactlyOnce);
          }
        }
        print(
            countSubscribed.toString() + waterMqttModelsStr.length.toString());
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

class WaterMqttModel {
  String code;

  WaterMqttInfo? info;
  WaterMqttData? data;

  WaterMqttModel({
    required this.code,
    this.info,
    this.data,
  });
}
