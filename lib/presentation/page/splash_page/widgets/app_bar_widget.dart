import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar appBarWidget(context){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      // Status bar color
      statusBarColor: Theme.of(context).primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
    elevation: 0,
    backgroundColor: Colors.white,
  );
}