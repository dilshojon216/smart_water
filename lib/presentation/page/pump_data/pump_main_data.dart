import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../cubit/signin_well_cubit/sign_in_well_cubit.dart';
import 'widgets/custom_search_delegate_mqtt.dart';
import 'widgets/dashboard_mqtt_well.dart';
import 'widgets/info_alert_well_mqtt.dart';
import 'widgets/last_mqtt_data_well.dart';
import 'widgets/login_alert.dart';
import 'widgets/pump_model_mqtt_data.dart';

class PumpMainData extends StatefulWidget {
  final String title;
  bool isLogin;
  String typeData;
  PumpMainData(
      {Key? key,
      required this.isLogin,
      required this.typeData,
      required this.title})
      : super(key: key);

  @override
  State<PumpMainData> createState() => _PumpMainDataState();
}

class _PumpMainDataState extends State<PumpMainData> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined),
            color: Theme.of(context).primaryColor,
            iconSize: 25),
        elevation: 2,
        actions: [
          IconButton(
              onPressed: () async {
                var _prefs = await SharedPreferences.getInstance();
                List<String> wellIMEiList =
                    _prefs.getStringList("wellIMEiList") ?? [];

                var postsCount = context.read<PumpModelMqttData>().countList;

                if (wellIMEiList.length == postsCount) {
                  var posts =
                      context.read<PumpModelMqttData>().getWaterMqttModels;
                  print(posts);

                  showSearch(
                      context: context,
                      delegate: CustomSearchDelegateWellMqtt(
                        posts,
                      ));
                } else {
                  show(LocaleKeys.water_data_text_1.tr());
                }
              },
              icon: Icon(Icons.search,
                  size: 25, color: Theme.of(context).primaryColor)),
          IconButton(
              onPressed: () async {
                var _prefs = await SharedPreferences.getInstance();
                List<String> wellIMEiList =
                    _prefs.getStringList("wellIMEiList") ?? [];

                var postsCount = context.read<PumpModelMqttData>().countList;
                var posts =
                    context.read<PumpModelMqttData>().getWaterMqttModels;
                if (wellIMEiList.length == postsCount) {
                  showInfo(posts);
                } else {
                  show(LocaleKeys.water_data_text_1.tr());
                }
              },
              icon: Icon(Icons.info_outlined,
                  size: 25, color: Theme.of(context).primaryColor)),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case '1':
                  getDataINfo();
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
          ? widget.typeData == "1"
              ? Center(child: Text("pump data http"))
              : LastMqttDataWell()
          : Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.well_data_text_1.tr(),
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

  getDataINfo() async {
    var _prefs = await SharedPreferences.getInstance();
    List<String> wellIMEiList = _prefs.getStringList("wellIMEiList") ?? [];

    var postsCount = context.read<PumpModelMqttData>().countList;
    var posts = context.read<PumpModelMqttData>().getWaterMqttModels;
    if (wellIMEiList.length == postsCount) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DashboradMqttWell(
                    waterMqttModels: posts,
                  )));
    } else {
      show(LocaleKeys.water_data_text_1.tr());
    }
  }

  clearData() async {
    var _prefs = await SharedPreferences.getInstance();

    _prefs.setString("wellInstall", "");
    _prefs.setString("wellIMEiList", "");

    setState(() {
      widget.isLogin = false;
    });
  }

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
                    LocaleKeys.login_alert_1.tr(),
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
                create: (context) => SignInWellCubit(),
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

  void showInfo(List<WellMqttModel> post) {
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
              content: InfoAlertWellMqtt(waterMqttModels: post),
            );
          },
        );
      },
    );
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _key.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: GoogleFonts.roboto(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500),
        ),
        duration: duration,
      ),
    );
  }
}
