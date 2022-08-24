import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import 'all_info_mqtt.dart';
import 'last_data_pump.dart';

class DataSearch extends SearchDelegate {
  List<PumpMqttData> pumpMqttData;
  DataSearch({
    required this.pumpMqttData,
  });
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
    List<PumpMqttData> matchQuery = [];
    for (var fruit in pumpMqttData) {
      if (fruit.stations.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
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
    List<PumpMqttData> matchQuery = [];

    for (var fruit in pumpMqttData) {
      if (fruit.stations.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
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
}
