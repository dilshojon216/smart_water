import 'package:flutter/material.dart';

Widget logoWidgets(size) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.09),
    child: const Center(
      child: Hero(
        tag: "logo_1",
        child: Image(
          image: AssetImage("assets/images/logo2.jpg"),
          fit: BoxFit.cover,
          height: 220,
          width: 220,
        ),
      ),
    ),
  );
}
