import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/well_mqtt_data.dart';
import '../../../../translations/locale_keys.g.dart';
import 'last_mqtt_data_well.dart';
import 'stations_mqtt_well_data.dart';

class CustomSearchDelegateWellMqtt extends SearchDelegate {
  List<WellMqttModel> aas;

  CustomSearchDelegateWellMqtt(this.aas);
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
    List<WellMqttModel> matchQuery = [];
    for (var fruit in aas) {
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
    List<WellMqttModel> matchQuery = [];

    for (var fruit in aas) {
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
                        LocaleKeys.well_data_text_4.tr(),
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
                        LocaleKeys.temp_title_text.tr(),
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
      return "";
    }
  }

  getTemp(String data) {
    try {
      int sath = int.parse(data);
      return "${(sath / 10.0).toStringAsFixed(2)} °C";
    } catch (e) {
      print(e);
      return "";
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
