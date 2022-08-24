import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cardSecondWidget(context, title, value, icon,
    {int asad = 1, bool iconVisibility = true}) {
  return Expanded(
    flex: asad,
    child: Card(
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: AutoSizeText(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                minFontSize: 14,
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: iconVisibility,
                    child: Expanded(
                      flex: 1,
                      child: Image(
                        image: AssetImage(
                          icon,
                        ),
                        fit: BoxFit.contain,
                        height: 45,
                        width: 45,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
