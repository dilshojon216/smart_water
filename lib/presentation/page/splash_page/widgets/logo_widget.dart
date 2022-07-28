import 'package:flutter/material.dart';

Widget logoWidget() {
  return const Center(
    child: Hero(
      tag: "logo_1",
      child: Image(
        image: AssetImage("assets/images/logo2.jpg"),
        fit: BoxFit.cover,
        height: 250,
        width: 250,
      ),
    ),
  );
}
