import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../data/model/water_info.dart';
import '../../../cubit/water_all_data_cubit/water_all_data_cubit.dart';
import 'data_mqtt_all.dart';
import 'info_station_all.dart';
import 'message_mqtt_data.dart';
import 'water_all_data.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<WaterInfo>? aas;
  final bool internetConnection;
  CustomSearchDelegate(this.aas, this.internetConnection);

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
    List<WaterInfo> matchQuery = [];
    for (var fruit in aas!) {
      if (fruit.name!.toLowerCase().contains(query.toLowerCase())) {
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
    List<WaterInfo> matchQuery = [];

    for (var fruit in aas!) {
      print(fruit.name);
      if (fruit.name!.toLowerCase().contains(query.toLowerCase())) {
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

  Widget _post(WaterInfo post, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (post.data != null && post.data!.id != -999) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => WaterAllDataCubit(),
                child: WaterAllData(
                  info: post,
                ),
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
                      color: post.data == null || post.data!.id == -999
                          ? Colors.red
                          : colorLine(dayString(post.data!.time)),
                      width: 2),
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Expanded(
                      flex: 7,
                      child: AutoSizeText(
                        "${post.name}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case '1':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoStationAll(
                                    info: post,
                                  ),
                                ),
                              );
                              break;
                            case '2':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DataMqttAll(
                                    info: post,
                                  ),
                                ),
                              );
                              break;
                            case '3':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageMqttData(
                                    info: post,
                                  ),
                                ),
                              );
                              break;
                            default:
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: '1',
                            child: Text(
                              LocaleKeys.search_water_text_1.tr(),
                              style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          PopupMenuItem(
                            value: '2',
                            child: Text(
                              LocaleKeys.search_water_text_2.tr(),
                              style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          PopupMenuItem(
                            value: '3',
                            child: Text(
                              LocaleKeys.search_water_text_3.tr(),
                              style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        child: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
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
                        post.data != null && post.data!.id != -999
                            ? "${post.data!.level!.toStringAsFixed(3)} m"
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
                        post.data != null && post.data!.id != -999
                            ? "${post.data!.volume!.toStringAsFixed(3)} m/s3"
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
                        post.data != null && post.data!.id != -999
                            ? timeString(post.data!.time!.toString())
                            : "",
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

  timeString(String time) {
    try {
      if (time.length == 12) {
        return "${time.substring(0, 4)}-${time.substring(4, 6)}-${time.substring(6, 8)} ${time.substring(8, 10)}:${time.substring(10, 12)}";
      }
    } catch (e) {
      return "";
    }
  }

  dayString(String? time) {
    try {
      if (time!.length == 12) {
        return DateTime(int.parse(time.substring(0, 4)),
            int.parse(time.substring(4, 6)), int.parse(time.substring(6, 8)));
      }
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Color colorLine(DateTime from) {
    try {} catch (e) {}
    int diffetnt = daysBetween(from, DateTime.now());
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
