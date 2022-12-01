import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/page/water_data/widgets/mqtt_search_delegate.dart';

import 'package:smart_water/presentation/page/water_data/widgets/water_mqtt_all.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../data/datasources/get_district_clinet.dart';
import '../../../data/datasources/get_region_clinet.dart';
import '../../../data/datasources/get_sensor_type_clinet.dart';
import '../../../data/db/database/smart_water_database.dart';
import '../../../data/model/water_info.dart';
import '../../cubit/last_water_data_cubit/last_water_data_cubit.dart';
import '../../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../home_page/widgets/app_drawer.dart';

import 'widgets/custom_search_delegate.dart';
import 'widgets/dashbord_http_water.dart';
import 'widgets/dashbord_mqtt_water.dart';
import 'widgets/info_alert.dart';
import 'widgets/info_alert_http.dart';
import 'widgets/last_data_water_page.dart';
import 'widgets/login_alert.dart';
import 'widgets/water_http_model.dart';
import 'widgets/water_mqtt_model.dart';

class WaterDataMain extends StatefulWidget {
  String title;
  bool isLogin;
  String typeData;
  WaterDataMain({
    Key? key,
    required this.title,
    required this.isLogin,
    required this.typeData,
  }) : super(key: key);

  @override
  State<WaterDataMain> createState() => _WaterDataMainState();
}

class _WaterDataMainState extends State<WaterDataMain> {
  bool isInstallWater = false;
  late StreamSubscription? subscription;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool internetConnection = false;
  String? typeWaterData;
  @override
  void initState() {
    super.initState();
    initValue();
    initValue2();
    //getData();
  }

  void initValue() async {
    setState(() {
      typeWaterData = widget.typeData;
    });
    print(typeWaterData);
  }

  List<WaterInfo> posts = [];
  getData() async {
    context.read<WaterHttpModel>().getWaterInfoeData();
    var posts = context.read<WaterHttpModel>().waterInfoLists;

    showSearch(
        context: context,
        delegate: CustomSearchDelegate(posts, internetConnection));
  }

  initValue2() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String? firstInstall = _prefs.getString("firstInstall").toString();

    if (firstInstall != "true") {
      GetSensorTypeClinet getSensorTypeClinet = GetSensorTypeClinet();
      GetDistrictClient getDistrictClient = GetDistrictClient();
      GetRegionClient getRegionClient = GetRegionClient();

      await getSensorTypeClinet.saveSensorType();

      String? district = _prefs.getString("District").toString();
      if (district != "true") {
        int value = await getDistrictClient.saveDistrict();
        if (value == 0) {
          _prefs.setString("District", "true");
        }
      }

      String? region = _prefs.getString("Region").toString();
      if (region != "true") {
        int value = await getRegionClient.saveRegion();
        if (value == 0) {
          _prefs.setString("Region", "true");
        }
      }
      _prefs.setString("firstInstall", "true");
    }
  }

  @override
  void dispose() {
    // if (subscription != null) {
    //   //subscription!.cancel();
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 25,
              color: Theme.of(context).primaryColor,
            )),
        elevation: 2,
        actions: [
          IconButton(
              onPressed: () {
                if (typeWaterData == "1") {
                  getData();
                } else if (typeWaterData == "2") {
                  var posts =
                      context.read<WaterMqttDataModel>().getWaterMqttModels;
                  showSearch(
                      context: context, delegate: MqttSearchDelegate(posts));
                }
              },
              icon: Icon(Icons.search,
                  size: 25, color: Theme.of(context).primaryColor)),
          IconButton(
              onPressed: () async {
                if (typeWaterData == "2") {
                  var _prefs = await SharedPreferences.getInstance();
                  List<String> wellIMEiList =
                      _prefs.getStringList("waterIMEIList") ?? [];

                  var postsCount = context.read<WaterMqttDataModel>().countList;

                  if (postsCount == wellIMEiList.length) {
                    var posts =
                        context.read<WaterMqttDataModel>().getWaterMqttModels;
                    showInfo(posts);
                  } else {
                    show(LocaleKeys.water_data_text_1.tr());
                  }
                } else if (typeWaterData == "1") {
                  context.read<WaterHttpModel>().getWaterInfoeData();
                  var posts = context.read<WaterHttpModel>().waterInfoLists;
                  showHttpInfo(posts);
                }
              },
              icon: Icon(Icons.info_outlined,
                  size: 25, color: Theme.of(context).primaryColor)),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case '1':
                  if (typeWaterData == "2") {
                    openDashboradMqtt();
                  } else {
                    openDashboradHttp();
                  }

                  break;
                case '2':
                  clearData();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '1',
                child: Text(
                  LocaleKeys.water_data_text_2.tr(),
                  style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuItem(
                value: '2',
                child: Text(
                  LocaleKeys.water_data_text_3.tr(),
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
        ],
        title: Center(
          child: Text(
            widget.title,
            style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: widget.isLogin
          ? typeWaterData == "1"
              ? BlocProvider(
                  create: (context) => LastWaterDataCubit(),
                  child: LastDataWaterPage(),
                )
              : typeWaterData == "2"
                  ? WaterMqttAll()
                  : Container()
          : Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.water_data_text_4.tr(),
                        style: GoogleFonts.roboto(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          showLogin();
                        },
                        child: Text(
                          LocaleKeys.water_data_text_5.tr(),
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  showHttpInfo(posts) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.water_data_text_6.tr(),
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: InfoAlertHttp(waterHttpsModels: posts),
            );
          },
        );
      },
    );
  }

  openDashboradHttp() async {
    context.read<WaterHttpModel>().getWaterInfoeData();
    var posts = context.read<WaterHttpModel>().waterInfoLists;

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashbordHttpWater(
          waterInfoList: posts,
        ),
      ),
    );
  }

  openDashboradMqtt() async {
    var _prefs = await SharedPreferences.getInstance();
    List<String> wellIMEiList = _prefs.getStringList("waterIMEIList") ?? [];

    // ignore: use_build_context_synchronously
    var postsCount = context.read<WaterMqttDataModel>().countList;

    if (postsCount == wellIMEiList.length) {
      // ignore: use_build_context_synchronously
      var posts = context.read<WaterMqttDataModel>().getWaterMqttModels;
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DashbordMqttWater(
                    waterMqttModels: posts,
                  )));
    } else {
      show(LocaleKeys.water_data_text_1.tr());
    }
  }

  clearData() async {
    var _prefs = await SharedPreferences.getInstance();
    _prefs.setString("token", "");

    _prefs.setString("userToken", "");

    _prefs.setString("waterInstall", "");
    _prefs.setString("stations", "");
    context.read<WaterHttpModel>().changeWaterInfo([]);
    setState(() {
      widget.isLogin = false;
    });
  }

  String errorMessage = "";
  void showLogin() async {
    bool a = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.water_data_text_5.tr(),
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: BlocProvider(
                create: (context) => SignInWaterCubit(),
                child: LoginAlert(),
              ),
            );
          },
        );
      },
    );
    if (a) {
      setState(() {
        widget.isLogin = true;
      });
    }
  }

  void showInfo(List<WaterMqttModel> post) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.water_data_text_6.tr(),
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: InfoAlert(waterMqttModels: post),
            );
          },
        );
      },
    );
  }

  show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
