import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget dataValueWidget(context, title, value, leftInt, rightInt,
    {Color? color}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Card(
      elevation: 5,
      child: Container(
        height: 40,
        color: color ?? Colors.white,
        margin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: leftInt,
              child: AutoSizeText(
                title,
                style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: rightInt,
              child: AutoSizeText(
                value,
                style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
