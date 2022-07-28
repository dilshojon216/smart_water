import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

Widget noDataErrorWidget(String? text) {
  return Center(
    child: Card(
      elevation: 5,
      child: Container(
          color: Colors.white,
          height: 150,
          width: 300,
          alignment: Alignment.center,
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.error,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    text == null
                        ? LocaleKeys.error_text_1.tr()
                        : text.contains("mqttdata not available")
                            ? LocaleKeys.error_text_1.tr()
                            : text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    ),
  );
}
