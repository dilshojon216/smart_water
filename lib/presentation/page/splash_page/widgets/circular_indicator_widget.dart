import 'package:flutter/material.dart';

Widget circularIndicatorWidget(context,size){
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.05),
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 5,
        )),
  );
}