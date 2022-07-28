import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle statusBar(context) {
  return SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: Theme.of(context).primaryColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );
}
