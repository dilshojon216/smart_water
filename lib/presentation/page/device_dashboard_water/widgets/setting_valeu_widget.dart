import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget settingValueWidget(
    context, title, hintText, conterller, typeKeybord, onChanged) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Card(
      elevation: 5,
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 10),
        margin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
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
              flex: 4,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: conterller,
                  keyboardType: typeKeybord,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.black54,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
