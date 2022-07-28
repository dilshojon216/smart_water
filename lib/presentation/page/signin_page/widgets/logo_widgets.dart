import 'package:flutter/material.dart';

Widget logoWidgets(size) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.01),
    child: const Center(
      child: Hero(
        tag: "logo_1",
        child: Image(
          image: AssetImage("assets/images/logo2.jpg"),
          fit: BoxFit.cover,
          height: 200,
          width: 200,
        ),
      ),
    ),
  );
}