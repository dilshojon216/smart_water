import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

Widget cardWidget(context, text, icons) {
  return Card(
    elevation: 5,
    child: Container(
      margin: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icons,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            text,
            style: GoogleFonts.roboto(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
