import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_water/presentation/page/water_data/widgets/no_internet_widget.dart';
import 'package:smart_water/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/datasources/water_clinet.dart';
import '../../../../data/model/water_info.dart';

import '../../../cubit/water_all_data_cubit/water_all_data_cubit.dart';
import 'data_mqtt_all.dart';
import 'info_station_all.dart';
import 'message_mqtt_data.dart';
import 'water_all_data.dart';

class LastDataWaterPage extends StatefulWidget {
  LastDataWaterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LastDataWaterPage> createState() => _LastDataWaterPageState();
}

class _LastDataWaterPageState extends State<LastDataWaterPage> {
  bool isLoading = false;
  bool internetConnection = false;
  String errorMessage = "";
  late StreamSubscription? subscription;

  final PagingController<int, WaterInfo> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    initValue();
    _pagingController.addPageRequestListener((pageKey) {
      print("pageKey: $pageKey");

      _fetchPage(pageKey);
    });

    testBackenServis();
  }

  void initValue() async {
    bool internetConnection1 = await InternetConnectionChecker().hasConnection;

    setState(() {
      internetConnection = internetConnection1;
    });

    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hashInternet = status == InternetConnectionStatus.connected;
      setState(() {
        internetConnection = hashInternet;
      });
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");
      if (token == null) {
        _pagingController.error = "Token is null";
      }
      final newItems = await _waterClinet.getLastData(token, pageKey);

      int _pageSize = newItems.pagination.pageCount;
      print("_pageSize: $_pageSize");
      final isLastPage = pageKey >= _pageSize;
      print("isLastPage: $isLastPage");
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.stations);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.stations, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  testBackenServis() async {
    await initializeService();
  }

  @override
  void dispose() {
    //_pagingController.dispose();
    if (subscription != null) {
      subscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return internetConnection ? _postList() : noInternetWidget();
  }

  Widget _postList() {
    print(_pagingController.nextPageKey);
    return PagedListView<int, WaterInfo>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<WaterInfo>(
        itemBuilder: (context, item, index) => _post(item, context),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _post(WaterInfo post, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (post.data!.id != -999 && post.data != null) {
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
                          onPressed: () {
                            goMaps(post);
                          },
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
    if (time.length == 12) {
      return "${time.substring(0, 4)}-${time.substring(4, 6)}-${time.substring(6, 8)} ${time.substring(8, 10)}:${time.substring(10, 12)}";
    }
  }

  dayString(String? time) {
    if (time!.length == 12) {
      return DateTime(int.parse(time.substring(0, 4)),
          int.parse(time.substring(4, 6)), int.parse(time.substring(6, 8)));
    }
  }

  Color colorLine(DateTime from) {
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

goMaps(WaterInfo post) {
  if (post.lon != "" && post.lat != "") {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${post.lat},${post.lon}';
    launchUrl(Uri.parse(googleUrl));
  }
}

List<WaterInfo> waterInfoList = [];
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

final WaterClinet _waterClinet = WaterClinet();
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  waterInfoList = [];
  int countPage = 1;
  int pageTotal = 0;
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  try {
    do {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");
      if (token == null) {
        service.stopSelf();
      }
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        final stations = await _waterClinet.getLastBack(token, countPage);
        if (stations != null) {
          print(stations.stations.length.toString() + countPage.toString());

          waterInfoList.addAll(stations.stations);
          pageTotal = stations.pagination.pageCount;
          int countTotal = stations.pagination.totalCount;
          print(stations.stations.length.toString() +
              waterInfoList.length.toString());
          countPage++;

          String userToken = jsonEncode(waterInfoList);

          print(userToken.toString());
          _prefs.setString("stations", userToken);
          print("change");

          if (waterInfoList.length == countTotal) {
            service.stopSelf();
          }

          if (countPage > pageTotal) {
            service.stopSelf();
          } else if (pageTotal == 1) {
            print("save");
            service.stopSelf();
          }
        }
      } else {
        service.stopSelf();
      }
    } while (countPage <= pageTotal);
  } catch (e) {
    print(e.toString() + "errror");
    service.stopSelf();
  }

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );
  }
}
