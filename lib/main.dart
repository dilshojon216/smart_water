import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/theme/app_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'presentation/routes/app_routes.dart';
import 'translations/codegen_loader.g.dart';

void main() async {
  var log = Logger();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(
      () => runApp(EasyLocalization(
            path: 'assets/translations',
            supportedLocales: const [
              Locale("uz"),
              Locale("ru"),
              Locale("en"),
            ],
            fallbackLocale: const Locale("en"),
            assetLoader: const CodegenLoader(),
            child: const MyApp(),
          )), (error, stacktrace) {
    log.e(error);
    FirebaseCrashlytics.instance.recordError(error, stacktrace, fatal: true);
    log.v(stacktrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Smart Water',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.whiteTheme,
        themeMode: ThemeMode.light,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutesNames.splashPage,
        builder: (context, widget) => ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget!),
          breakpoints: const [
            ResponsiveBreakpoint.resize(350, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
            ResponsiveBreakpoint.resize(1700, name: 'XL'),
          ],
        ),
      ),
    );
  }
}
