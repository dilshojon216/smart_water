import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonTerminal(context, text, onClick) {
  return Expanded(
    child: Container(
      height: 40,
      color: Theme.of(context).primaryColor,
      child: TextButton(
        onPressed: onClick,
        child: Text(
          text,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}
