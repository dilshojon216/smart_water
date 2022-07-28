import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/routes/app_routes.dart';

import '../../../core/other/constants.dart';
import '../../../translations/locale_keys.g.dart';
import '../../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../water_data/water_data.dart';
import '../water_data/widgets/water_http_model.dart';
import '../water_data/widgets/water_mqtt_model.dart';
import 'widgets/button_widgets.dart';
import 'widgets/logo_widgets.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({Key? key}) : super(key: key);

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  late SharedPreferences _prefs;
  bool waterInstall = false;
  bool wellInstall = false;
  String typeWaterData = "1";
  @override
  void initState() {
    super.initState();
    initValue();
  }

  initValue() async {
    _prefs = await SharedPreferences.getInstance();
  }

  initValue2() async {
    waterInstall = _prefs.getString("waterInstall").toString() == "true";

    if (_prefs.getInt("valueWater").toString() == null) {
      typeWaterData = "1";
    } else {
      typeWaterData = _prefs.getInt("valueWater").toString();
    }
    print(typeWaterData);
  }

  setLanguage(String text) {
    switch (text) {
      case "uzb":
        context.setLocale(const Locale("en"));
        _prefs.setInt("LANG", 1);
        break;
      case "ru":
        context.setLocale(const Locale("ru"));
        _prefs.setInt("LANG", 2);
        break;
      case "cyril":
        context.setLocale(const Locale("uz"));
        _prefs.setInt("LANG", 3);
        break;
    }

    _prefs.setString(LANGUAGE, 'true');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SignInWaterCubit(),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<WaterMqttDataModel>(
                  create: (_) => WaterMqttDataModel()),
              ChangeNotifierProvider<WaterHttpModel>(
                  create: (_) => WaterHttpModel()),
            ],
            child: WaterDataMain(
                title: LocaleKeys.water_main_title.tr(),
                isLogin: waterInstall,
                typeData: typeWaterData),
          ),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            logoWidgets(size),
            SizedBox(
              height: size.height * 0.08,
            ),
            ButtonWidgets(
              size: size,
              text: "O'zbekcha",
              onTap: () {
                setLanguage("uzb");
              },
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            ButtonWidgets(
              size: size,
              text: "Pусский",
              onTap: () {
                setLanguage("ru");
              },
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            ButtonWidgets(
              size: size,
              text: "Ўзбекча",
              onTap: () {
                setLanguage("cyril");
              },
            ),
          ],
        ),
      ),
    );
  }
}
