import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:smart_water/presentation/page/bluetooth_terminal/bluetooth_terminal.dart';
import 'package:smart_water/presentation/page/change_language/change_language.dart';
import 'package:smart_water/presentation/page/home_page/home_page.dart';
import 'package:smart_water/presentation/page/pump_data/pump_main_data.dart';
import 'package:smart_water/presentation/page/select_language_page/select_language_page.dart';
import 'package:smart_water/presentation/page/signin_page/signin_page.dart';
import 'package:smart_water/presentation/page/user_about/user_about.dart';
import 'package:smart_water/presentation/page/water_data/water_data.dart';
import 'package:smart_water/presentation/page/well_data/well_main_data.dart';

import '../../translations/locale_keys.g.dart';

import '../cubit/sign_in_pump_cubit/signin_pump_cubit.dart';
import '../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../page/device_settings/device_main_settings.dart';
import '../page/device_settings/widgets/water_device_conntion.dart';
import '../page/splash_page/splash_page.dart';

import '../page/water_flow_calc/water_flow_calc.dart';
import '../page/well_data/pump_viewmodel.dart';

class AppRoutesNames {
  static const String splashPage = "/splashPage";
  static const String signInPage = "/signInPage";
  static const String homePage = "/homePage";
  static const String selectLangPage = "/selectLangPage";
  static const String waterMainData = "/";
  static const String wellMainData = "/wellMain";
  static const String pumpMainData = "/pumpMain";
  static const String deviceSettings = "/deviceSettings";
  static const String waterFlowCalc = "/waterFlowCalc";
  static const String changeLanguage = "/changeLanguage";
  static const String userAbout = "/userAbout";
  static const String deviceSettingsWater = "/deviceSettings/water";
  static const String deviceSettingsWell = "/deviceSettings/well";
  static const String deviceSettingsPump = "/deviceSettings/pump";
  static const String deviceDashobordWater = "/deviceSettings/water/dashboard";
  static const String deviceDashobordTeminalWater =
      "/deviceSettings/water/dashboard/terminal";
  static const String signInWater = "/signInWater";
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutesNames.splashPage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: AppRoutesNames.splashPage, arguments: args),
          builder: (_) => const SplashPage(),
        );
      case AppRoutesNames.homePage:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: AppRoutesNames.homePage, arguments: args),
          builder: (_) => const HomePage(),
        );
      case AppRoutesNames.signInPage:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutesNames.signInPage),
          builder: (_) => const SignInPage(),
        );
      case AppRoutesNames.selectLangPage:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutesNames.selectLangPage),
          builder: (_) => const SelectLanguagePage(),
        );

      case AppRoutesNames.wellMainData:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: AppRoutesNames.wellMainData, arguments: args),
          builder: (_) => BlocProvider(
            create: (context) => SignInPumpCubit(),
            child: ChangeNotifierProvider(
              create: (context) => PumpViewModel(),
              child: WellMainData(
                title: LocaleKeys.pump_main_title.tr(),
              ),
            ),
          ),
        );

      case AppRoutesNames.deviceSettings:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutesNames.deviceSettings),
          builder: (_) => DeviceMainSettings(
            title: LocaleKeys.device_main_title.tr(),
          ),
        );

      case AppRoutesNames.waterFlowCalc:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutesNames.waterFlowCalc),
          builder: (_) => WaterFlowCalc(
            title: LocaleKeys.water_flow_calc_title.tr(),
          ),
        );
      case AppRoutesNames.changeLanguage:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutesNames.changeLanguage),
          builder: (_) => ChangeLanguage(
            title: LocaleKeys.language_main_title.tr(),
          ),
        );

      case AppRoutesNames.userAbout:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutesNames.userAbout),
          builder: (_) => UserAbout(
            title: "Sozlamalar",
          ),
        );

      case AppRoutesNames.deviceSettingsWater:
        return MaterialPageRoute(
          settings: RouteSettings(
              name: AppRoutesNames.deviceSettingsWater, arguments: args),
          builder: (_) => WaterDeviceConntion(
            title: "Qurilma bilan bog'lanish",
          ),
        );

      case AppRoutesNames.deviceDashobordTeminalWater:
        return MaterialPageRoute(
          settings: RouteSettings(
              name: AppRoutesNames.deviceDashobordTeminalWater,
              arguments: args),
          builder: (_) => BluetoothTerminal(
            title: 'Terminal',
          ),
        );
      default:
        return MaterialPageRoute(
          settings:
              RouteSettings(name: AppRoutesNames.splashPage, arguments: args),
          builder: (_) => const SplashPage(),
        );
    }
  }
}
