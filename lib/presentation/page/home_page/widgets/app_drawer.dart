import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/routes/app_routes.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../../../cubit/signin_well_cubit/sign_in_well_cubit.dart';
import '../../pump_data/pump_main_data.dart';
import '../../pump_data/widgets/pump_model_mqtt_data.dart';
import '../../water_data/water_data.dart';
import '../../water_data/widgets/water_http_model.dart';
import '../../water_data/widgets/water_mqtt_model.dart';
import 'header_drawer.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool waterInstall = false;
  String? typeWaterData = "1";
  String typePumpData = "2";
  bool wellInstall = false;
  bool pumperInstall = false;

  @override
  void initState() {
    super.initState();
    initValue2();
  }

  initValue2() async {
    var _prefs = await SharedPreferences.getInstance();

    waterInstall = _prefs.getString("waterInstall").toString() == "true";
    wellInstall = _prefs.getString("wellInstall").toString() == "true";
    pumperInstall = _prefs.getString("pumperInstall").toString() == "true";
    typeWaterData = _prefs.getInt("valueWater").toString();
    if (typeWaterData == null) {
      typeWaterData = "1";
      _prefs.setInt("valueWater", 1);
    } else {
      typeWaterData = _prefs.getInt("valueWater").toString();
    }

    print(typeWaterData);

    if (_prefs.getInt("valueWell").toString().isEmpty) {
      typePumpData = "2";
      _prefs.setInt("valueWell", 2);
    } else {
      typePumpData = _prefs.getInt("valueWell").toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 6,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          headerDrawer("Smart Water", "Smart Solutions System", context),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
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
                        typeData: typeWaterData!,
                      ),
                    ),
                  ),
                ),
              );
            },
            leading:
                const Icon(Icons.location_on, color: Colors.white, size: 35),
            title: Text(
              LocaleKeys.water_main_title.tr(),
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SignInWellCubit(),
                    child: ChangeNotifierProvider(
                      create: (context) => PumpModelMqttData(),
                      child: PumpMainData(
                        title: LocaleKeys.well_main_title.tr(),
                        isLogin: wellInstall,
                        typeData: typePumpData,
                      ),
                    ),
                  ),
                ),
              );
            },
            leading:
                const Icon(Icons.location_on, color: Colors.white, size: 35),
            title: Text(
              LocaleKeys.well_main_title.tr(),
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutesNames.wellMainData,
                  arguments: pumperInstall);
            },
            leading:
                const Icon(Icons.location_on, color: Colors.white, size: 35),
            title: Text(
              LocaleKeys.pump_main_title.tr(),
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutesNames.deviceSettings);
            },
            leading: const Icon(Icons.app_settings_alt,
                color: Colors.white, size: 35),
            title: Text(
              LocaleKeys.device_main_title.tr(),
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed(AppRoutesNames.waterFlowCalc);
          //   },
          //   leading: const Icon(Icons.calculate, color: Colors.white, size: 35),
          //   title: Text(
          //     LocaleKeys.water_flow_calc_title.tr(),
          //     style: GoogleFonts.roboto(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.white),
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutesNames.changeLanguage);
            },
            leading: const Icon(Icons.language, color: Colors.white, size: 35),
            title: Text(
              LocaleKeys.language_main_title.tr(),
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutesNames.userAbout);
            },
            leading: const Icon(Icons.settings, color: Colors.white, size: 35),
            title: Text(
              "Sozlamalar",
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
