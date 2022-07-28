import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget noInternetWidget() {
  return Center(
    child: Card(
      elevation: 5,
      child: Container(
          color: Colors.white,
          height: 200,
          width: 350,
          alignment: Alignment.center,
          child: AutoSizeText(
            "No internet connection",
            style: GoogleFonts.roboto(color: Colors.blue, fontSize: 18),
          )),
    ),
  );
}
