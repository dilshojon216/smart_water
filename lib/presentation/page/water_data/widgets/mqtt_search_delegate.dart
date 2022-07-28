import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../translations/locale_keys.g.dart';
import 'info_water_mqtt_data.dart';
import 'water_mqtt_all.dart';

class MqttSearchDelegate extends SearchDelegate {
  List<WaterMqttModel> waterMqttModels;

  MqttSearchDelegate(
    this.waterMqttModels,
  );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
        icon:
            Icon(Icons.clear, size: 25, color: Theme.of(context).primaryColor),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_outlined,
          size: 25, color: Theme.of(context).primaryColor),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<WaterMqttModel> matchQuery = [];
    for (var fruit in waterMqttModels) {
      if (fruit.info != null) {
        if (fruit.info!.p3.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(fruit);
        }
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return _post(result, context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<WaterMqttModel> matchQuery = [];

    for (var fruit in waterMqttModels) {
      if (fruit.info != null) {
        if (fruit.info!.p3.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(fruit);
        }
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return _post(result, context);
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
}
