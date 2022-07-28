import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

Widget cardWidgets(context, text, icons, onTap) {
  return Card(
    elevation: 5,
    child: Container(
      margin: const EdgeInsets.all(5),
      child: TextButton(
        onPressed: onTap,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: CircleAvatar(
                maxRadius: 40,
                child: Icon(
                  icons,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
